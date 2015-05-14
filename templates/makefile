COMPILE    = g++
MAIN       = Main.cpp
SOURCES    = Class.cpp Included.cpp
OBJECTS    = $(MAIN:.cpp=.o) $(SOURCES:.cpp=.o)
DEPS       = $(SOURCES:.cpp=.h)
EXECUTABLE = a.out

all: $(MAIN) $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS) $(DEPS)
	$(COMPILE) $(OBJECTS) -o $(EXECUTABLE)

$(OBJECTS): $(DEPS)

clean:
	rm -rf *o $(EXECUTABLE)

