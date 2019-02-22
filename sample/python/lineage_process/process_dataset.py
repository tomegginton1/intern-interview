from lineage_process import parsing_example

INPUT_FILE = 'tree.json'

if __name__ == "__main__":
    with open(INPUT_FILE) as fp:
        print(fp.readline())

    parsing_example.json_parsing_example()
