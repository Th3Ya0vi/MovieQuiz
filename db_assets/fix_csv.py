import sys


def main():
    args = sys.argv[1:]
    csv_file = args[0]
    num_cols = int(args[1])

    ff = open(csv_file, 'r+')
    build_str = []

    for line in ff.readlines():
        line = line.strip()
        split = line.split(',')
        newline = ','.join(split[:num_cols])
        build_str.append(newline)
    ff.close()

    output = open('new_'+csv_file, 'w')
    output.write('\n'.join(build_str))
    output.close()

main()
