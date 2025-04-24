# Predicting Closed Questions on Stack Overflow

This project uses a combination of traditional NLP techniques and transformer-based deep learning models to predict whether a Stack Overflow question will be closed at the time of posting — and if closed, why.

---

##  Dataset & Preprocessing

### Why Not Use the Full 3.3M Dataset?
The full dataset (33L+ entries) posed computational and memory challenges, especially with class imbalance. Hence, a balanced sample of *1.4 lakh entries* (50:50 open/closed) was extracted for efficient model experimentation.

### Exploratory Data Analysis:
- *Vocabulary Size:* 411,272 tokens (without stop words)
- *Top Words:* '1', '0', '2', 'using', 'code', 'new', 'like', 'c', 'java'...
- *BoW Sparsity:* 99.61%
- *TF-IDF Sparsity:* 99.61%

---

## Feature Engineering & Models

### Classical Approaches

#### TF-IDF
- *Multi-Class Classification:* 63.27%
- *Binary Classification:* 73.51%

#### Word2Vec Embeddings (CBOW & Skip-Gram)
- *Binary Classification:*
  - CBOW: 71.59%
  - Skip-Gram: 72.17%
- *Multi-Class Classification:*
  - CBOW: 61.68%
  - Skip-Gram: 61.97%

### Misclassification Check
Manual inspection showed word embeddings lost sentence structure. We transitioned to *sentence-level embeddings* using SBERT.

---

## Sentence-BERT (SBERT)

| Input Combination | Accuracy |
|-------------------|----------|
| Title + BodyMarkdown | 75.52% |
| Title only | 71.34% |
| BodyMarkdown only | 74.93% |
| Title + Body + Tags + Code | 76.98% |
| With/without code (varied combos) | 75%–76.9% |
| Tags via Word2Vec + SBERT | 76.67% |
| Summary + Title + Body + Tags + Code | 76.89% |

#### SVM (Linear Kernel)
- Same rich inputs as above: *77.06%*

---

## Neural Networks (using SBERT features)

| Architecture | Accuracy |
|--------------|----------|
| General NN + Dropout (512) | 77.67% |
| General NN (128/64) | ~77.3% |
| Residual (128/64) | ~77.5% |
| DenseNet (128/64) | ~77.5% |

*Multiclass NN using SBERT*: 67.23%

---

## BERT-based Approaches

### Pretrained BERT
- Inputs: Title + Body + Tags + Code
- Accuracy: *76.82%*

### Cascading Classification
- First model predicts open or closed
- If closed, second model predicts the *closure reason*
- Final Accuracy: *66.60%*

### Fine-Tuned BERT (3 epochs)
- *Best Accuracy:* 🎯 *79.58%*

---

## Summary of Model Progression

| Model | Type | Accuracy |
|-------|------|----------|
| TF-IDF | Traditional | 73.51% |
| Word2Vec Skip-Gram | Embedding | 72.17% |
| SBERT + Logistic Regression | Sentence Embedding | 76.98% |
| SBERT + SVM | Sentence Embedding | 77.06% |
| Neural Networks | Deep Learning | 77.67% |
| Pretrained BERT | Transformer | 76.82% |
| Fine-Tuned BERT | Transformer (Fine-Tuned) | *79.58%* |
| Cascading LogReg Models | Hybrid | 66.60% |

---

## Highlights

- Sentence-level embeddings (SBERT) outperform traditional methods.
- Domain adaptation (Fine-tuned BERT) significantly boosts performance.
- Richer input combinations lead to better generalization.
- Cascading architecture is modular but sensitive to first-stage error.

---

## Future Work

- Try *RoBERTa / DeBERTa* for deeper contextual representation.
- Use *GPT / LLaMA* for zero-/few-shot classification.
- Integrate *user metadata* or edit history.
- Explore *Code-aware transformers* (like CodeBERT).
- Design *lightweight models* for real-time moderation.

---

## Authors

- *CH SRICHERAN* – sricheran320@gmai.com
- *ADITYA V* –
