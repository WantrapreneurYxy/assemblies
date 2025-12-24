import parser
import jieba

sentences = [
    "我无可奈何地红温了",
    "我并非人类",
    "我踢球",
    "你真善良",
    "你真温柔善良大度",
    "愚蠢的我并非人类",
    "愚蠢的我踢球",
    "我并非愚蠢的人类",
    "我踢硬邦邦的球",
    "聪明的我并非愚蠢的人类",
    "愚蠢的我踢硬邦邦的球",
    "愚蠢的我愤怒地踢一颗硬邦邦的球"
]

# Ensure dictionary words are added to jieba
for word in parser.CHINESE_LEXEME_DICT.keys():
    jieba.add_word(word)

print("Running Chinese Parsing Simulations...")
for s in sentences:
    print(f"\nParsing: {s}")
    tokens = list(jieba.cut(s))
    # Manual adjustments for tokenization (mirroring parser logic)
    new_tokens = []
    for token in tokens:
        if token == "踢球":
            new_tokens.extend(["踢", "球"])
        else:
            new_tokens.append(token)
    print(f"Tokens: {new_tokens}")

    try:
        parser.parse(sentence=s, language="Chinese", verbose=False)
    except Exception as e:
        print(f"Error parsing {s}: {e}")
