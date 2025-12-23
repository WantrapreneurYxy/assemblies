import parser

sentences = [
    "我无可奈何地红温了",
    "我并非人类",
    "我踢球",
    "你真善良",
    "愚蠢的我并非人类",
    "愚蠢的我踢球",
    "我并非愚蠢的人类",
    "我踢硬邦邦的球",
    "聪明的我并非愚蠢的人类",
    "愚蠢的我踢硬邦邦的球",
    "愚蠢的我愤怒地踢一颗硬邦邦的球"
]

print("Running Chinese Parsing Simulations...")
for s in sentences:
    print(f"\nParsing: {s}")
    try:
        parser.parse(sentence=s, language="Chinese", verbose=False)
    except Exception as e:
        print(f"Error parsing {s}: {e}")
