#include <algorithm>
#include <cctype>
#include <cmath>
#include <cstdint>
#include <fstream>
#include <iomanip>
#include <iostream>
#include <map>
#include <numeric>
#include <sstream>
#include <string>
#include <vector>

namespace {

struct SttlogRow {
    int asserted_ready = 0;
    int deasserted = 0;
    std::string current_condition;
    std::string desired_condition;
    int count = 0;
    int aux = 0;
};

struct PatLogSummary {
    std::size_t line_count = 0;
    std::size_t sample_count = 0;
    std::size_t non_zero_count = 0;
    int max_value = 0;
    double mean = 0.0;
};

struct RetailConnectSummary {
    bool present = false;
    bool aligned_after8_records = false;
    bool mixed_stable_tail_layout = false;
    std::size_t record_count = 0;
    std::size_t stable_tail_records = 0;
    std::size_t versioned_prefix_records = 0;
    std::string variant = "unknown";
};

struct IegSummary {
    bool present = false;
    std::size_t size = 0;
    std::size_t body_words = 0;
    std::size_t zero_words = 0;
    std::size_t value_48_words = 0;
    bool sparse_fixed_schedule = false;
    double rigidity_gradient = 0.0;
};

struct BehaviorProfile {
    std::map<std::string, SttlogRow> sttlog_rows;
    PatLogSummary pat_log;
    RetailConnectSummary retail_connect;
    IegSummary ieg;
    std::vector<std::uint8_t> aibo_id;
    std::size_t awaking_size = 0;
    std::size_t ieg_size = 0;
    std::size_t fvar_size = 0;
    std::size_t gvar_size = 0;
    std::size_t sidr_size = 0;
    int wake_intensity = 0;
    int shutdown_resistance = 0;
    int social_attachment = 0;
    int routine_rigidity = 0;
    double routine_rigidity_signal = 0.0;
    int adaptability = 0;
};

struct SimulationState {
    std::string mode = "offline";
    int engagement = 0;
    double routine_hold = 0.0;
    int idle_ticks = 0;
    int fatigue = 0;
    int shutdown_deferrals = 0;
};

double clamp01(double value) {
    return std::max(0.0, std::min(1.0, value));
}

std::string trim(const std::string& text) {
    std::size_t start = 0;
    while (start < text.size() && std::isspace(static_cast<unsigned char>(text[start]))) {
        ++start;
    }
    std::size_t end = text.size();
    while (end > start && std::isspace(static_cast<unsigned char>(text[end - 1]))) {
        --end;
    }
    return text.substr(start, end - start);
}

std::vector<std::string> split_ws(const std::string& line) {
    std::istringstream iss(line);
    std::vector<std::string> parts;
    std::string part;
    while (iss >> part) {
        parts.push_back(part);
    }
    return parts;
}

std::string join_path(const std::string& root, const std::string& rel) {
    if (!root.empty() && root.back() == '/') {
        return root + rel;
    }
    return root + "/" + rel;
}

std::size_t file_size_or_zero(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) {
        return 0;
    }
    in.seekg(0, std::ios::end);
    return static_cast<std::size_t>(in.tellg());
}

std::vector<std::uint8_t> read_binary(const std::string& path) {
    std::ifstream in(path, std::ios::binary);
    if (!in) {
        return {};
    }
    return std::vector<std::uint8_t>(std::istreambuf_iterator<char>(in), std::istreambuf_iterator<char>());
}

std::uint32_t read_le_u32(const std::vector<std::uint8_t>& data, std::size_t offset) {
    if (offset + 4 > data.size()) {
        return 0;
    }
    return static_cast<std::uint32_t>(data[offset]) |
           (static_cast<std::uint32_t>(data[offset + 1]) << 8) |
           (static_cast<std::uint32_t>(data[offset + 2]) << 16) |
           (static_cast<std::uint32_t>(data[offset + 3]) << 24);
}

IegSummary load_ieg_summary(const std::string& path) {
    IegSummary summary;
    const std::vector<std::uint8_t> data = read_binary(path);
    if (data.empty()) {
        return summary;
    }

    summary.present = true;
    summary.size = data.size();
    if (data.size() <= 0x40) {
        return summary;
    }

    for (std::size_t offset = 0x40; offset + 4 <= data.size(); offset += 4) {
        const std::uint32_t value = read_le_u32(data, offset);
        ++summary.body_words;
        if (value == 0) {
            ++summary.zero_words;
        }
        if (value == 0x42480000U) {
            ++summary.value_48_words;
        }
    }

    // Current specimen-side clue: a very sparse tail with many zero words and
    // repeated 0x42480000 values where the lean packaged baseline keeps a
    // denser changing schedule-like tail.
    if (summary.body_words > 0 &&
        summary.zero_words >= (summary.body_words / 3) &&
        summary.value_48_words >= (summary.body_words / 4)) {
        summary.sparse_fixed_schedule = true;
    }

    if (summary.body_words > 0) {
        const double zero_ratio =
            static_cast<double>(summary.zero_words) / static_cast<double>(summary.body_words);
        const double value_48_ratio =
            static_cast<double>(summary.value_48_words) / static_cast<double>(summary.body_words);
        const double zero_component =
            0.7 * (1.0 / (1.0 + std::exp(-200.0 * (zero_ratio - (1.0 / 3.0)))));
        const double value_48_component =
            0.3 * clamp01((value_48_ratio - 0.20) / 0.30);
        summary.rigidity_gradient = clamp01(zero_component + value_48_component);
    }

    return summary;
}

RetailConnectSummary load_retail_connect_summary(const std::string& path) {
    RetailConnectSummary summary;
    const std::vector<std::uint8_t> data = read_binary(path);
    if (data.empty()) {
        return summary;
    }

    summary.present = true;
    if (data.size() < 8 || ((data.size() - 8) % 24) != 0) {
        return summary;
    }

    const std::string first8_hex = [&data]() {
        std::ostringstream out;
        for (std::size_t index = 0; index < 8 && index < data.size(); ++index) {
            out << std::hex << std::setw(2) << std::setfill('0')
                << static_cast<int>(data[index]);
        }
        return out.str();
    }();

    summary.aligned_after8_records = true;
    summary.record_count = (data.size() - 8) / 24;

    // Current retail MW CONNECT.CFG clue: 38 records after byte 8, with
    // records 0-20 versioned and 21-37 stable across MIND 2/MIND 3.
    if (summary.record_count == 38) {
        summary.versioned_prefix_records = 21;
        summary.stable_tail_records = 17;
        summary.mixed_stable_tail_layout = true;
        if (first8_hex == "0e207d53993b8df4") {
            summary.variant = "retail-mind2-known";
        } else if (first8_hex == "8dde29f70da8bc9f") {
            summary.variant = "retail-mind3-known";
        } else {
            summary.variant = "retail-38-record-unknown-variant";
        }
    }

    return summary;
}

std::map<std::string, SttlogRow> load_sttlog(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        throw std::runtime_error("missing STTLOG: " + path);
    }

    std::map<std::string, SttlogRow> rows;
    std::string line;
    while (std::getline(in, line)) {
        const std::vector<std::string> parts = split_ws(line);
        if (parts.size() != 7) {
            continue;
        }
        if (parts[0].size() != 4 || !std::isxdigit(static_cast<unsigned char>(parts[0][0]))) {
            continue;
        }

        SttlogRow row;
        row.asserted_ready = std::stoi(parts[1]);
        row.deasserted = std::stoi(parts[2]);
        row.current_condition = parts[3];
        row.desired_condition = parts[4];
        row.count = std::stoi(parts[5]);
        row.aux = std::stoi(parts[6]);
        rows[parts[0]] = row;
    }
    return rows;
}

PatLogSummary load_pat_log(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        throw std::runtime_error("missing PAT.LOG: " + path);
    }

    PatLogSummary summary;
    std::vector<int> values;
    std::string line;
    while (std::getline(in, line)) {
        line = trim(line);
        if (line.empty()) {
            continue;
        }
        ++summary.line_count;
        const std::vector<std::string> parts = split_ws(line);
        for (const std::string& part : parts) {
            bool numeric = !part.empty();
            for (char ch : part) {
                if (!std::isdigit(static_cast<unsigned char>(ch))) {
                    numeric = false;
                    break;
                }
            }
            if (!numeric) {
                continue;
            }
            const int value = std::stoi(part);
            values.push_back(value);
            if (value != 0) {
                ++summary.non_zero_count;
            }
            summary.max_value = std::max(summary.max_value, value);
        }
    }

    summary.sample_count = values.size();
    if (!values.empty()) {
        const long long total = std::accumulate(values.begin(), values.end(), 0LL);
        summary.mean = static_cast<double>(total) / static_cast<double>(values.size());
    }
    return summary;
}

int row_signal(const std::map<std::string, SttlogRow>& rows, const std::string& key) {
    const auto it = rows.find(key);
    if (it == rows.end()) {
        return 0;
    }
    return it->second.count + it->second.aux;
}

BehaviorProfile load_profile(const std::string& tree_root) {
    BehaviorProfile profile;
    profile.sttlog_rows = load_sttlog(join_path(tree_root, "OPEN-R/APP/DATA/P/STTLOG"));
    profile.pat_log = load_pat_log(join_path(tree_root, "OPEN-R/MW/DATA/P/PAT.LOG"));
    profile.retail_connect = load_retail_connect_summary(
        join_path(tree_root, "OPEN-R/MW/CONF/CONNECT.CFG"));
    profile.ieg = load_ieg_summary(join_path(tree_root, "OPEN-R/APP/DATA/P/IEG.CFG"));
    profile.aibo_id = read_binary(join_path(tree_root, "OPEN-R/SYSTEM/DATA/P/AIBO-ID"));
    profile.awaking_size = file_size_or_zero(join_path(tree_root, "OPEN-R/APP/DATA/P/AWAKING.CFG"));
    profile.ieg_size = file_size_or_zero(join_path(tree_root, "OPEN-R/APP/DATA/P/IEG.CFG"));
    profile.fvar_size = file_size_or_zero(join_path(tree_root, "OPEN-R/APP/DATA/P/FVAR"));
    profile.gvar_size = file_size_or_zero(join_path(tree_root, "OPEN-R/APP/DATA/P/GVAR"));
    profile.sidr_size = file_size_or_zero(join_path(tree_root, "OPEN-R/APP/DATA/P/SIDRDATA.BIN"));

    profile.wake_intensity = 1;
    if (profile.awaking_size > 0) {
        profile.wake_intensity += 1;
    }
    if (row_signal(profile.sttlog_rows, "1000") >= 8) {
        profile.wake_intensity += 1;
    }
    if (row_signal(profile.sttlog_rows, "0047") >= 80) {
        profile.wake_intensity += 1;
    }

    profile.shutdown_resistance = 0;
    const auto row0400 = profile.sttlog_rows.find("0400");
    if (row0400 != profile.sttlog_rows.end() && row0400->second.desired_condition != "0000") {
        profile.shutdown_resistance += 2;
    }
    const auto row0300 = profile.sttlog_rows.find("0300");
    if (row0300 != profile.sttlog_rows.end() && row0300->second.desired_condition != "0100") {
        profile.shutdown_resistance += 1;
    }
    const auto row1200 = profile.sttlog_rows.find("1200");
    if (row1200 != profile.sttlog_rows.end() && row1200->second.asserted_ready == 1) {
        profile.shutdown_resistance += 1;
        profile.social_attachment += row1200->second.count / 6;
    }

    profile.social_attachment += row_signal(profile.sttlog_rows, "0046") / 4;
    profile.social_attachment += row_signal(profile.sttlog_rows, "0055") / 8;
    const bool row0400_active =
        row0400 != profile.sttlog_rows.end() && row0400->second.desired_condition != "0000";
    if (profile.pat_log.sample_count > 0 && profile.pat_log.mean > 5.0) {
        profile.social_attachment += 1;
    }
    if (profile.ieg.rigidity_gradient > 0.0) {
        profile.social_attachment += static_cast<int>(std::round(profile.ieg.rigidity_gradient * 2.0));
        profile.routine_rigidity_signal = profile.ieg.rigidity_gradient;
        profile.routine_rigidity = static_cast<int>(std::round(profile.ieg.rigidity_gradient * 6.0));
        if (row0400_active) {
            profile.shutdown_resistance += static_cast<int>(
                std::round(profile.ieg.rigidity_gradient));
        }
    }
    if (profile.retail_connect.mixed_stable_tail_layout) {
        profile.social_attachment += 1;
    }

    profile.adaptability = 1;
    if (profile.ieg_size > 0) {
        profile.adaptability += 1;
    }
    if (profile.ieg.rigidity_gradient > 0.45 && profile.adaptability > 0) {
        profile.adaptability -= 1;
    }
    if (profile.fvar_size > 0 && profile.gvar_size > 0) {
        profile.adaptability += 1;
    }
    if (profile.pat_log.non_zero_count > profile.pat_log.sample_count / 2) {
        profile.adaptability += 1;
    }
    if (profile.retail_connect.mixed_stable_tail_layout) {
        profile.adaptability += 1;
    }

    return profile;
}

std::vector<std::string> load_scenario(const std::string& path) {
    std::ifstream in(path);
    if (!in) {
        throw std::runtime_error("missing scenario: " + path);
    }

    std::vector<std::string> events;
    std::string line;
    while (std::getline(in, line)) {
        line = trim(line);
        if (line.empty() || line[0] == '#') {
            continue;
        }
        events.push_back(line);
    }
    return events;
}

std::string aibo_id_string(const std::vector<std::uint8_t>& id) {
    if (id.empty()) {
        return "missing";
    }
    std::ostringstream out;
    for (std::size_t index = 0; index < id.size(); ++index) {
        if (index != 0) {
            out << ' ';
        }
        out << std::hex << std::setw(2) << std::setfill('0')
            << static_cast<int>(id[index]);
    }
    return out.str();
}

void print_profile(const BehaviorProfile& profile) {
    std::cout << "Baseline MIND 2 behavior simulator\n";
    std::cout << "model: heuristic host-side profile\n";
    std::cout << "aibo-id: " << aibo_id_string(profile.aibo_id) << "\n";
    std::cout << "sttlog rows: " << profile.sttlog_rows.size() << "\n";
    std::cout << "pat.log samples: " << profile.pat_log.sample_count
              << ", mean=" << std::fixed << std::setprecision(2) << profile.pat_log.mean
              << ", max=" << profile.pat_log.max_value << "\n";
    std::cout << "signals:\n";
    std::cout << "  wake_intensity=" << profile.wake_intensity << "\n";
    std::cout << "  shutdown_resistance=" << profile.shutdown_resistance << "\n";
    std::cout << "  social_attachment=" << profile.social_attachment << "\n";
    std::cout << "  routine_rigidity=" << profile.routine_rigidity << "\n";
    std::cout << "  routine_rigidity_signal=" << std::fixed << std::setprecision(2)
              << profile.routine_rigidity_signal << "\n";
    std::cout << "  adaptability=" << profile.adaptability << "\n";
    if (profile.retail_connect.present) {
        std::cout << "  mw_connect_records=" << profile.retail_connect.record_count << "\n";
        std::cout << "  mw_connect_variant=" << profile.retail_connect.variant << "\n";
        if (profile.retail_connect.mixed_stable_tail_layout) {
            std::cout << "  mw_connect_partition=versioned:"
                      << profile.retail_connect.versioned_prefix_records
                      << ",stable:" << profile.retail_connect.stable_tail_records << "\n";
        } else if (profile.retail_connect.aligned_after8_records) {
            std::cout << "  mw_connect_partition=aligned-retail-layout-without-known-21/17-split\n";
        } else {
            std::cout << "  mw_connect_partition=unclassified\n";
        }
    }
    std::cout << "state files:\n";
    std::cout << "  AWAKING.CFG=" << profile.awaking_size << " bytes\n";
    std::cout << "  IEG.CFG=" << profile.ieg_size << " bytes\n";
    if (profile.ieg.present) {
        std::cout << "    ieg_tail_zero_words=" << profile.ieg.zero_words
                  << "/" << profile.ieg.body_words << "\n";
        std::cout << "    ieg_tail_48_words=" << profile.ieg.value_48_words << "\n";
        std::cout << "    ieg_rigidity_gradient=" << std::fixed << std::setprecision(2)
                  << profile.ieg.rigidity_gradient << "\n";
        std::cout << "    ieg_pattern="
                  << (profile.ieg.sparse_fixed_schedule ? "sparse-fixed-schedule" : "dense-or-mixed")
                  << "\n";
    }
    std::cout << "  FVAR=" << profile.fvar_size << " bytes\n";
    std::cout << "  GVAR=" << profile.gvar_size << " bytes\n";
    std::cout << "  SIDRDATA.BIN=" << profile.sidr_size << " bytes\n";
    std::cout << "\n";
}

void note_expected_writes(const std::string& event) {
    if (event == "boot") {
        std::cout << "  likely-writes: STTLOG, PAT.LOG\n";
    } else if (event == "head_touch" || event == "back_touch" || event == "chest_button") {
        std::cout << "  likely-writes: PAT.LOG, FVAR, GVAR\n";
    } else if (event == "nearby_presence") {
        std::cout << "  likely-writes: PAT.LOG\n";
    } else if (event == "shutdown_request") {
        std::cout << "  likely-writes: STTLOG, PAT.LOG\n";
    } else if (event == "sleep_request") {
        std::cout << "  likely-writes: STTLOG, AWAKING.CFG\n";
    } else if (event == "schedule_disruption") {
        std::cout << "  likely-writes: STTLOG, AWAKING.CFG, IEG.CFG\n";
    }
}

void simulate_event(const std::string& event, const BehaviorProfile& profile, SimulationState& state) {
    std::cout << "event: " << event << "\n";

    if (event == "boot") {
        state.mode = "awake";
        state.engagement = profile.social_attachment / 2;
        state.routine_hold = profile.routine_rigidity_signal * 6.0;
        state.idle_ticks = 0;
        state.fatigue = 0;
        std::cout << "  transition: offline -> awake\n";
        std::cout << "  startup-audio: ";
        if (profile.wake_intensity >= 3) {
            std::cout << "doo doo doo\n";
        } else {
            std::cout << "soft boot chime\n";
        }
        if (profile.retail_connect.mixed_stable_tail_layout) {
            std::cout << "  mw-connect-hypothesis: mixed retail connection table "
                      << "(" << profile.retail_connect.versioned_prefix_records
                      << " versioned / " << profile.retail_connect.stable_tail_records
                      << " stable records)\n";
        }
        std::cout << "  symbolic-behavior: initialize interaction memory and active posture\n";
        note_expected_writes(event);
        return;
    }

    if (event == "observe_startup_audio") {
        std::cout << "  expectation: ";
        if (profile.wake_intensity >= 3) {
            std::cout << "triple startup tone remains plausible\n";
        } else {
            std::cout << "startup tone should be quieter or shorter\n";
        }
        return;
    }

    if (event == "nearby_presence") {
        if (profile.social_attachment >= 8) {
            state.engagement += 1;
        }
        std::cout << "  symbolic-behavior: register nearby presence without direct contact\n";
        std::cout << "  cue-salience=neutral\n";
        std::cout << "  engagement=" << state.engagement << "\n";
        std::cout << "  routine_hold=" << state.routine_hold << "\n";
        note_expected_writes(event);
        return;
    }

    if (event == "head_touch" || event == "back_touch") {
        if (event == "head_touch") {
            state.engagement += 3;
        } else {
            state.engagement += 1;
        }
        if (event == "head_touch" && state.routine_hold > 0) {
            state.routine_hold = std::max(0.0, state.routine_hold - 1.0);
        }
        std::cout << "  symbolic-behavior: increase engagement and keep posture awake\n";
        std::cout << "  touch-salience="
                  << (event == "head_touch" ? "social-high" : "social-low") << "\n";
        std::cout << "  engagement=" << state.engagement << "\n";
        std::cout << "  routine_hold=" << state.routine_hold << "\n";
        note_expected_writes(event);
        return;
    }

    if (event == "chest_button") {
        state.fatigue += 1;
        std::cout << "  symbolic-behavior: acknowledge chest input, consider mode transition\n";
        std::cout << "  fatigue=" << state.fatigue << "\n";
        note_expected_writes(event);
        return;
    }

    if (event == "shutdown_request") {
        const int resistance =
            profile.shutdown_resistance + state.engagement +
            static_cast<int>(std::round(state.routine_hold)) - state.fatigue;
        const bool retail_connect_bias =
            profile.retail_connect.mixed_stable_tail_layout && state.engagement >= 1;
        if ((profile.shutdown_resistance >= 3 || retail_connect_bias) &&
            resistance >= 6 && state.shutdown_deferrals == 0) {
            ++state.shutdown_deferrals;
            state.fatigue += 1;
            std::cout << "  symbolic-behavior: resist immediate shutdown, remain socially engaged\n";
            std::cout << "  verdict: defer power-off once\n";
            if (retail_connect_bias) {
                std::cout << "  note: mixed MW retail connection layout increases deferral plausibility\n";
            }
        } else {
            state.mode = "powering_down";
            std::cout << "  symbolic-behavior: accept shutdown sequence\n";
            std::cout << "  verdict: power-down accepted\n";
        }
        note_expected_writes(event);
        return;
    }

    if (event == "sleep_request") {
        if (state.routine_hold >= 2.75 && profile.shutdown_resistance >= 3) {
            std::cout << "  symbolic-behavior: postpone sleep to preserve a fixed routine state\n";
        } else if (state.engagement >= 5 && profile.shutdown_resistance >= 2) {
            std::cout << "  symbolic-behavior: postpone sleep because engagement remains high\n";
        } else {
            state.mode = "sleep";
            std::cout << "  symbolic-behavior: enter sleep state\n";
        }
        note_expected_writes(event);
        return;
    }

    if (event == "schedule_disruption") {
        if (state.routine_hold >= 2.75 && profile.routine_rigidity_signal >= 0.35) {
            state.fatigue += 1;
            state.routine_hold = std::max(
                0.0, state.routine_hold - std::max(0.5, 1.5 - profile.routine_rigidity_signal));
            std::cout << "  symbolic-behavior: preserve the current routine despite schedule disruption\n";
            std::cout << "  verdict: routine state preserved\n";
        } else if (state.engagement >= 5 && profile.shutdown_resistance >= 2) {
            state.engagement -= 1;
            std::cout << "  symbolic-behavior: redirect disruption into renewed social attention\n";
            std::cout << "  verdict: seek interaction rather than preserve routine\n";
        } else {
            state.mode = "alert";
            std::cout << "  symbolic-behavior: accept disruption and reorient state\n";
            std::cout << "  verdict: routine broken\n";
        }
        std::cout << "  engagement=" << state.engagement << "\n";
        std::cout << "  routine_hold=" << state.routine_hold << "\n";
        std::cout << "  fatigue=" << state.fatigue << "\n";
        note_expected_writes(event);
        return;
    }

    if (event == "idle_tick") {
        ++state.idle_ticks;
        if (state.engagement > 0) {
            state.engagement -= 1;
        }
        if (profile.routine_rigidity_signal > 0.0) {
            if (state.routine_hold > 0.0 && state.idle_ticks > 1) {
                state.routine_hold = std::max(
                    0.0, state.routine_hold - std::max(0.5, 1.25 - profile.routine_rigidity_signal));
            }
        } else if (state.routine_hold > 0.0) {
            state.routine_hold = 0.0;
        }
        state.fatigue += 1;
        std::cout << "  symbolic-behavior: idle decay\n";
        std::cout << "  engagement=" << state.engagement << "\n";
        std::cout << "  routine_hold=" << state.routine_hold << "\n";
        std::cout << "  fatigue=" << state.fatigue << "\n";
        return;
    }

    std::cout << "  note: event is not modeled yet\n";
}

void usage() {
    std::cout << "Usage: mind2-behavior-sim --tree <stick-tree> --scenario <scenario-file>\n";
}

}  // namespace

int main(int argc, char** argv) {
    std::string tree_root;
    std::string scenario_path;

    for (int index = 1; index < argc; ++index) {
        const std::string arg = argv[index];
        if (arg == "--tree" && index + 1 < argc) {
            tree_root = argv[++index];
        } else if (arg == "--scenario" && index + 1 < argc) {
            scenario_path = argv[++index];
        } else if (arg == "-h" || arg == "--help") {
            usage();
            return 0;
        } else {
            std::cerr << "error: unknown or incomplete argument: " << arg << "\n";
            usage();
            return 1;
        }
    }

    if (tree_root.empty() || scenario_path.empty()) {
        usage();
        return 1;
    }

    try {
        const BehaviorProfile profile = load_profile(tree_root);
        const std::vector<std::string> events = load_scenario(scenario_path);
        SimulationState state;

        print_profile(profile);
        std::cout << "scenario: " << scenario_path << "\n";
        std::cout << "events: " << events.size() << "\n\n";

        for (const std::string& event : events) {
            simulate_event(event, profile, state);
        }

        std::cout << "\nfinal-state:\n";
        std::cout << "  mode=" << state.mode << "\n";
        std::cout << "  engagement=" << state.engagement << "\n";
        std::cout << "  routine_hold=" << state.routine_hold << "\n";
        std::cout << "  fatigue=" << state.fatigue << "\n";
        std::cout << "  shutdown_deferrals=" << state.shutdown_deferrals << "\n";
        std::cout << "\n";
        std::cout << "note: this simulator does not execute Sony retail binaries.\n";
        std::cout << "note: it is a hypothesis-driven behavior harness over preserved persistent state.\n";
    } catch (const std::exception& ex) {
        std::cerr << "error: " << ex.what() << "\n";
        return 1;
    }

    return 0;
}
