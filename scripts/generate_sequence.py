import argparse
import json

def main(args):
    with open(args.sequence_file, "r") as f:
        data = json.load(f)

    with open(args.output, "w") as o:
        o.write("""#ifndef _SEQUENCE_H
#define _SEQUENCE_H
#include "midi.h"

""")

        sequences = data["sequences"]
        for sequence in sequences:
            name = sequence["sequence_name"]
            steps_name = sequence["steps_name"]
            channel = sequence["channel"]
            channel_string = f"CHANNEL_{channel}"
            divisor = sequence["divisor"]
            steps = sequence["steps"]
            num_steps = len(steps)
            sequence_string = """MIDISequence_TypeDef %s = {
    %i,
    0,
    %i,
    %s,
    %s
};

""" % (name, divisor, num_steps, channel_string, steps_name)

            

            step_string_array = []
            for i, step in enumerate(steps):
                end_of_sequence = 0
                if i == len(steps) - 1:
                    end_of_sequence = 1
                note = step["note"]
                type = step["type"]
                glide = 0 if step["glide"] == False else 1
                velocity = step["velocity"]
                step_string = f"{{{type},{note},{velocity},{glide},{end_of_sequence}}}"
                step_string_array.append(step_string)

            steps_concat = ",\n\t".join(step_string_array)
        
            steps_string = """MIDIStep_TypeDef %s[] = {
    %s
};

""" % (steps_name, steps_concat)

            o.write(steps_string)
            o.write(sequence_string)

        o.write("#endif")

if __name__ == "__main__":
    parser = argparse.ArgumentParser()

    parser.add_argument(
        "-f",
        "--sequence-file",
        type=str
    )

    parser.add_argument(
        "-o",
        "--output",
        type=str
    )

    args = parser.parse_args()

    main(args)