### 形式语言与自动机课程设计：中文自然语言解析器

此项目是对论文 [Brain computation by assemblies of neurons](pnas.org/doi/10.1073/pnas.2001893117) 中提出的基于集合演算的英文自然语言解析器的改造，实现了对中文基本句式的解析功能

#### 一键运行

该项目的依赖库如 `requirements.txt`：

- numpy
- scipy
- pptree
- matplotlib
- jieba

Windows 用户可运行 `setup_and_run.bat` 一键配置虚拟环境并运行程序：

```shell
setup_and_run.bat
```

Linux 用户可运行 `setup_and_run.sh`脚本，同样会使用 pip 安装上述依赖并运行程序

```shell
chmod +x setup_and_run.sh
```

```shell
./setup_and_run.sh
```

#### 功能说明

本项目实现的中文自然语言解析器可解析的句式如下：

1. 主语 + （副词） + 不及物动词（我（无可奈何地）红温了）
2. 主语 + 表语/及物动词 + 宾语（我并非人类/我踢球）
3. 主语 + 表语 + 形容词（你真善良）
4. 形容词 + 主语 + 表语/及物动词 + 宾语（愚蠢的我并非人类/愚蠢的我踢球）
5. 主语 + 表语/及物动词 + 形容词 + 宾语（我并非愚蠢的人类/我踢硬邦邦的球）
6. 形容词 + 主语 + 表语/及物动词 + 形容词 + 宾语（聪明的我并非愚蠢的人类/愚蠢的我踢硬邦邦的球）
7. （形容词） + 主语 + （副词） + 及物动词 + （量词）+ （形容词） + 宾语（（愚蠢的）我（愤怒地）踢（一颗）（硬邦邦的）球）
8. 已实现加分项：主语 + 表语 + 连续多个形容词（你真温柔善良大度）

解析结果示例如下：

```shell
Parsing: 我无可奈何地红温了
Tokens: ['我', '无可奈何地', '红温了']
Got dependencies:
[['红温了', '我', 'SUBJ'], ['红温了', '无可奈何地', 'ADVERB']]

Parsing: 我并非人类
Tokens: ['我', '并非', '人类']
Got dependencies:
[['并非', '人类', 'OBJ'], ['并非', '我', 'SUBJ']]

Parsing: 我踢球
Tokens: ['我', '踢', '球']
Got dependencies:
[['踢', '球', 'OBJ'], ['踢', '我', 'SUBJ']]

Parsing: 你真善良
Tokens: ['你', '真', '善良']
Got dependencies:
[['善良', '你', 'SUBJ'], ['善良', '真', 'ADVERB']]

Parsing: 你真温柔善良大度
Tokens: ['你', '真', '温柔', '善良', '大度']
Got dependencies:
[['温柔', '你', 'SUBJ'], ['温柔', '真', 'ADVERB'], ['善良', '你', 'SUBJ'], ['善良', '真', 'ADVERB'], ['大度', '你', 'SUBJ'], ['大度', '真', 'ADVERB']]

Parsing: 愚蠢的我并非人类
[['并非', '人类', 'OBJ'], ['并非', '我', 'SUBJ'], ['我', '愚蠢的', 'ADJ']]
Got dependencies:
Got dependencies:
[['并非', '人类', 'OBJ'], ['并非', '我', 'SUBJ'], ['人类', '愚蠢的', 'ADJ'], ['我', '聪明的', 'ADJ']]

Parsing: 愚蠢的我踢硬邦邦的球
Tokens: ['愚蠢的', '我', '踢', '硬邦邦的', '球']
Got dependencies:
[['踢', '球', 'OBJ'], ['踢', '我', 'SUBJ'], ['球', '硬邦邦的', 'ADJ'], ['我', '愚蠢的', 'ADJ']]

Parsing: 愚蠢的我愤怒地踢一颗硬邦邦的球
Tokens: ['愚蠢的', '我', '愤怒地', '踢', '一颗', '硬邦邦的', '球']
Got dependencies:
[['踢', '愤怒地', 'ADVERB'], ['踢', '球', 'OBJ'], ['踢', '我', 'SUBJ'], ['球', '一颗', 'DET'], ['球', '硬邦邦的', 'ADJ'], ['我', '愚蠢的', 'ADJ']]
```
