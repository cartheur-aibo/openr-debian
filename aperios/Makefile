CXX ?= g++
CXXFLAGS ?= -std=c++17 -O2 -Wall -Wextra -pedantic

APERIOS_INCLUDE := $(CURDIR)/include
HELLO_WORLD_SRC := ../samples/common/HelloWorld/HelloWorld/HelloWorld.cc
HELLO_WORLD_RUNNER := src/hello_world_lifecycle.cpp
HELLO_WORLD_INCLUDES := -I$(APERIOS_INCLUDE) -I../samples/common/HelloWorld/HelloWorld
MIND2_SIM_SRC := src/mind2_behavior_sim.cpp
MIND2_SIM := mind2-behavior-sim
MIND2_TREE ?= ../features/mind2-behavior-research/build/sensitive-stick
MIND2_SCENARIO ?= ../simulator/scenarios/mind2-shutdown-probe.scn

.PHONY: all clean run-hello-world run-mind2-behavior-sim

all: hello-world-host $(MIND2_SIM)

hello-world-host: $(HELLO_WORLD_SRC) $(HELLO_WORLD_RUNNER)
	$(CXX) $(CXXFLAGS) $(HELLO_WORLD_INCLUDES) $^ -o $@

$(MIND2_SIM): $(MIND2_SIM_SRC)
	$(CXX) $(CXXFLAGS) -I$(APERIOS_INCLUDE) $< -o $@

run-hello-world: hello-world-host
	./hello-world-host

run-mind2-behavior-sim: $(MIND2_SIM)
	./$(MIND2_SIM) --tree "$(MIND2_TREE)" --scenario "$(MIND2_SCENARIO)"

clean:
	rm -f hello-world-host $(MIND2_SIM)
