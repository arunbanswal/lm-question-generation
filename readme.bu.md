[![license](https://img.shields.io/badge/License-MIT-brightgreen.svg)](https://github.com/asahi417/lmqg/blob/master/LICENSE)
[![PyPI version](https://badge.fury.io/py/lmqg.svg)](https://badge.fury.io/py/lmqg)
[![PyPI pyversions](https://img.shields.io/pypi/pyversions/lmqg.svg)](https://pypi.python.org/pypi/lmqg/)
[![PyPI status](https://img.shields.io/pypi/status/lmqg.svg)](https://pypi.python.org/pypi/lmqg/)

# Question and Answer Generation with Language Models

<p align="center">
  <img src="https://raw.githubusercontent.com/asahi417/lm-question-generation/master/assets/qag.png" width="500">
    <em> Figure 1: Three distinct QAG approaches. </em>
</p>

The `lmqg` is a python library for question and answer generation (QAG) with language models (LMs). Here, we consider 
paragraph-level QAG, where user will provide a context (paragraph or document), and the model will generate a list of 
question and answer pairs on the context. With `lmqg`, you can do following things:
- ***QA Generation on Paragraph:*** Given a paragraph, generate a list of question and answer pairs in *8* languages (en/fr/ja/ko/ru/it/es/de).
- ***QAG Model Training:*** On a dataset containing triples of *paragraph*, *question*, and *answer*, fine-tune LMs to achieve your own QAG model.
- ***QAG Model Evaluation:*** Evaluate a QAG model on QAAlignedScore.
- ***QAG Model Hosting:*** Host your QAG model on a web application or a restAPI server.
 
### A bit more about QAG models 📝
Our QAG models can be grouped into three types: **Pipeline**, **Multitask**, 
and **End2end** (see Figure 1). The **Pipeline** consists of question generation (QG) and answer extraction (AE) models independently,
where AE will parse all the sentences in the context to extract answers, and QG will generate questions on the answers.
The **Multitask** follows same architecture as the **Pipeline**, but the QG and AE models are shared model fine-tuned jointly.
Finally, **End2end** model will generate a list of question and answer pairs in an end-to-end manner.
In practice, **Pipeline** and **Multitask** generate more question and answer pairs, while **End2end** generates less but a few times faster, 
and the quality of the generated question and answer pairs depend on language (please check the leader board to know more about itlink to the leaderboard).
All types are available in the *8* diverse languages (en/fr/ja/ko/ru/it/es/de) via `lmqg`, and the models are all shared on HuggingFace (link to the model card).
To know more about QAG, please check [our ACL 2023 paper](TBA) that describes the QAG models more in detail.

### Is it different from Question Generation (QG)? 🤔 
All the functionalities support question generation as well. Our QG model assumes user to specify an answer in addition to a context,
and the QG model will generate a question that is answerable by the answer given the context.
To know more about QG, please check [our EMNLP 2022 paper](https://aclanthology.org/2022.emnlp-main.42/) that describes the QG models more in detail.
  

This is the official repository of the paper
["Generative Language Models for Paragraph-Level Question Generation, EMNLP 2022 main conference"](https://aclanthology.org/2022.emnlp-main.42/).
This repository includes following contents:
- ***QG-Bench***, the first ever multilingual/multidomain QG benchmark.
- ***Multilingual/multidomain QG models*** fine-tuned on QG-Bench.
- A python library ***`lmqg`*** developed for question generation in python as well as QG model fine-tuning/evaluation.
- ***AutoQG***, a web application hosting QG models where user can test the model output interactively. 

### Table of Contents  
1. **[QG-Bench: multilingual & multidomain QG datasets (+ fine-tuned models)](https://github.com/asahi417/lm-question-generation/blob/master/QG_BENCH.md)**
2. **[LMQG: python library to fine-tune/evaluate QG model](#lmqg-language-model-for-question-generation-)**
3. **[AutoQG: web application hosting multilingual QG models](#autoqg)**
4. **[RestAPI: run model prediction via restAPI](#rest-api-with-huggingface-inference-api)**

Please cite following paper if you use any resource:
```
@inproceedings{ushio-etal-2022-generative,
    title = "{G}enerative {L}anguage {M}odels for {P}aragraph-{L}evel {Q}uestion {G}eneration",
    author = "Ushio, Asahi  and
        Alva-Manchego, Fernando  and
        Camacho-Collados, Jose",
    booktitle = "Proceedings of the 2022 Conference on Empirical Methods in Natural Language Processing",
    month = dec,
    year = "2022",
    address = "Abu Dhabi, U.A.E.",
    publisher = "Association for Computational Linguistics",
}
```

## LMQG: Language Model for Question Generation 🚀
[![Open In Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/drive/13izkdp2l7G2oeh_fwL7xJdR_67HMK_hQ?usp=sharing)

The `lmqg` is a python library to fine-tune seq2seq language models ([T5](https://arxiv.org/pdf/1910.10683.pdf), [BART](https://arxiv.org/pdf/1910.13461.pdf)) 
on the question generation task and provide an API to host the model prediction via [huggingface](https://huggingface.co/).
Let's install `lmqg` via pip first.
```shell
pip install lmqg
```

### Generate Question & Answer

- ***Generate Question on Answers:*** This is a basic usecase of our QG models, where user provides a paragraph and an answer to generate a question that is answerable by the answer given the paragraph.
See [MODEL CARD](https://github.com/asahi417/lm-question-generation/blob/master/QG_BENCH.md#qg-models) for the available models.

```python
from lmqg import TransformersQG
# initialize model
model = TransformersQG(language='en', model='lmqg/t5-large-squad-qg')
# a list of paragraph
context = [
    "William Turner was an English painter who specialised in watercolour landscapes",
    "William Turner was an English painter who specialised in watercolour landscapes"
]
# a list of answer (same size as the context)
answer = [
    "William Turner",
    "English"
]
# model prediction
question = model.generate_q(list_context=context, list_answer=answer)
print(question)
[
    'Who was an English painter who specialised in watercolour landscapes?',
    'What nationality was William Turner?'
]
```

- ***Generate Question & Answer Pairs:*** Instead of specifying an answer, user can let QG model to generate an answer on the paragraph, and generate question on it sequentially.
This functionality is only available for the QG models fine-tuned with answer extraction see [MODEL CARD](https://github.com/asahi417/lm-question-generation/blob/master/QG_BENCH.md#models-with-answer-extraction) for the full list of models with answer extraction (model alias usually has a suffix of `-qg-ae`).
  
```python
from lmqg import TransformersQG
# initialize model
model = TransformersQG(language='en', model='lmqg/t5-large-squad-qg-ae')
# paragraph to generate pairs of question and answer
context = "William Turner was an English painter who specialised in watercolour landscapes. He is often known as William Turner of Oxford or just Turner of Oxford to distinguish him from his contemporary, J. M. W. Turner. Many of Turner's paintings depicted the countryside around Oxford. One of his best known pictures is a view of the city of Oxford from Hinksey Hill."
# model prediction
question_answer = model.generate_qa(context)
# the output is a list of tuple (question, answer)
print(question_answer)
[
    ('Who was an English painter who specialised in watercolour landscapes?', 'William Turner'),
    ("What was William Turner's nickname?", 'William Turner of Oxford'),
    ("What did many of Turner's paintings depict around Oxford?", 'countryside'),
    ("What is one of William Turner's best known paintings?", 'a view of the city of Oxford')
]
```


### Model Evaluation
The evaluation tool reports `BLEU4`, `ROUGE-L`, `METEOR`, `BERTScore`, and `MoverScore` following [QG-Bench](https://github.com/asahi417/lm-question-generation/blob/master/QG_BENCH.md).
From command line, run following command 
```shell
lmqg-eval -m "lmqg/t5-large-squad-qg" -e "./eval_metrics" -d "lmqg/qg_squad" -l "en"
```
where `-m` is a model alias on huggingface or path to local checkpoint, `-e` is the directly to export the metric file, `-d` is the dataset to evaluate, and `-l` is the language of the test set.
Instead of running model prediction, you can provide a prediction file instead to avoid computing it each time.
```shell
lmqg-eval --hyp-test '{your prediction file}' -e "./eval_metrics" -d "lmqg/qg_squad" -l "en"
```
The prediction file should be a text file of model generation in each line in the order of `test` split in the target dataset
([sample](https://huggingface.co/lmqg/t5-large-squad/raw/main/eval/samples.validation.hyp.paragraph_sentence.question.lmqg_qg_squad.default.txt)).
Check `lmqg-eval -h` to display all the options.

### Model Training
<p align="center">
  <img src="https://raw.githubusercontent.com/asahi417/lm-question-generation/master/assets/grid_search.png" width="650">
</p>

To fine-tune QG model, we employ a two-stage hyper-parameter optimization, described as above diagram.
Following command is to run the fine-tuning with parameter optimization.
```shell
lmqg-train-search -c "tmp_ckpt" -d "lmqg/qg_squad" -m "t5-small" -b 64 --epoch-partial 5 -e 15 --language "en" --n-max-config 1 \
  -g 2 4 --lr 1e-04 5e-04 1e-03 --label-smoothing 0 0.15
```
Check `lmqg-train-search -h` to display all the options.

Fine-tuning models in python follows below.  
```python
from lmqg import GridSearcher
trainer = GridSearcher(
    checkpoint_dir='tmp_ckpt',
    dataset_path='lmqg/qg_squad',
    model='t5-small',
    epoch=15,
    epoch_partial=5,
    batch=64,
    n_max_config=5,
    gradient_accumulation_steps=[2, 4], 
    lr=[1e-04, 5e-04, 1e-03],
    label_smoothing=[0, 0.15]
)
trainer.run()
```


## AutoQG

<p align="center">
  <img src="https://raw.githubusercontent.com/asahi417/lm-question-generation/master/assets/autoqg.gif" width="500">
</p>

***AutoQG ([https://autoqg.net](https://autoqg.net/))*** is a free web application hosting our QG models.
The QG models are listed at the [QG-Bench page](https://github.com/asahi417/lm-question-generation/blob/master/QG_BENCH.md).

## Rest API with huggingface inference API

We provide a rest API which hosts the model inference through huggingface inference API. You need huggingface API token to run your own API and install dependencies as below.
```shell
pip install lmqg[api]
```
Swagger UI is available at [`http://127.0.0.1:8088/docs`](http://127.0.0.1:8088/docs), when you run the app locally (replace the address by your server address).

### Build
- Build/Run Local (command line):
```shell
export API_TOKEN={Your Huggingface API Token}
uvicorn app:app --reload --port 8088
uvicorn app:app --host 0.0.0.0 --port 8088
```

- Build/Run Local (docker):
```shell
docker build -t lmqg/app:latest . --build-arg api_token={Your Huggingface API Token}
docker run -p 8080:8080 lmqg/app:latest
```

### API Description
You must pass the huggingface api token via the environmental variable `API_TOKEN`.
The main endpoint is `question_generation`, which has following parameters,

| Parameter        | Description                                                                         |
| ---------------- | ----------------------------------------------------------------------------------- |
| **input_text**   | input text, a paragraph or a sentence to generate question |
| **language**     | language |
| **qg_model**     | question generation model |
| **answer_model** | answer extraction model |

and return a list of dictionaries with `question` and `answer`. 
```shell
{
  "qa": [
    {"question": "Who founded Nintendo Karuta?", "answer": "Fusajiro Yamauchi"},
    {"question": "When did Nintendo distribute its first video game console, the Color TV-Game?", "answer": "1977"}
  ]
}
```

## Misc
Following link is useful if you need to reproduce the results in our paper.
- [Model Fine-tuning/Evaluation](https://github.com/asahi417/lm-question-generation/tree/master/misc/emnlp_2022/qg_model_training)
- [QA based Evaluation](https://github.com/asahi417/lm-question-generation/tree/master/misc/emnlp_2022/qa_based_evaluation)
- [NQG model baseline](https://github.com/asahi417/lm-question-generation/tree/master/misc/emnlp_2022/nqg_baseline)


## Citation
Please cite following paper if you use any resource.

- [***Generative Language Models for Paragraph-Level Question Generation, EMNLP 2022 Main***](https://aclanthology.org/2022.emnlp-main.42/): The QG models.
```
@inproceedings{ushio-etal-2022-generative,
    title = "{G}enerative {L}anguage {M}odels for {P}aragraph-{L}evel {Q}uestion {G}eneration",
    author = "Ushio, Asahi  and
        Alva-Manchego, Fernando  and
        Camacho-Collados, Jose",
    booktitle = "Proceedings of the 2022 Conference on Empirical Methods in Natural Language Processing",
    month = dec,
    year = "2022",
    address = "Abu Dhabi, U.A.E.",
    publisher = "Association for Computational Linguistics",
}
```

- [***TBA, ACL 2022 Finding***](tba): The QAG models.
```
@inproceedings{ushio-etal-2023-tba,
    title = "TBA",
    author = "Ushio, Asahi  and
        Alva-Manchego, Fernando  and
        Camacho-Collados, Jose",
    booktitle = "Proceedings of the 61th Annual Meeting of the Association for Computational Linguistics",
    month = Jul,
    year = "2023",
    address = "Toronto, Canada",
    publisher = "Association for Computational Linguistics",
}
```

- [***A Practical Toolkit for Multilingual Question and Answer Generation, ACL 2022, System Demonstration***](tba): The library and demo.

```
@inproceedings{ushio-etal-2023-a-practical-toolkit
    title = "A Practical Toolkit for Multilingual Question and Answer Generation, ACL 2022, System Demonstration",
    author = "Ushio, Asahi  and
        Alva-Manchego, Fernando  and
        Camacho-Collados, Jose",
    booktitle = "Proceedings of the 61th Annual Meeting of the Association for Computational Linguistics: System Demonstrations",
    month = Jul,
    year = "2023",
    address = "Toronto, Canada",
    publisher = "Association for Computational Linguistics",
}
```