# quantum_classifier.py

import ollama
import pandas as pd
import re
import os
import csv

desired_model = 'llama4:scout'
input_csv_path = 'I:/Data_for_practice/Rfiles/QuanTech/quant_pub_ed_eu.csv'
output_csv_path = 'C:/Users/user/Desktop/[git]/QuantTechEU/QuanTech2/quantum_classification_results.csv'

def build_prompt(title: str, abstract: str) -> str:
    return f"""
    Below is the title and abstract of an academic paper. Determine whether this paper is related to *quantum science*. 
    "Quantum science" refers to research and technologies based on quantum mechanical principles, such as superposition, entanglement, quantum tunneling, or quantum computing. This includes fields like quantum physics, quantum information science, quantum optics, and quantum materials.
    Respond clearly with either "Related" or "Not Related". Briefly explain your reasoning.

    Title: {title}

    Abstract: {abstract}

    Answer format:
    - Relevance: Related / Not Related
    - Reason: (brief explanation)
    """

def load_and_clean_data(path: str) -> pd.DataFrame:
    df = pd.read_csv(path, index_col=0)
    df = df[['pubid', 'abstract', 'itemtitle']]
    df = df[df['abstract'].notnull()].drop_duplicates().reset_index(drop=True)
    return df

def append_result_to_csv(result_dict: dict, path: str, is_first: bool):
    with open(path, mode='a', newline='', encoding='utf-8') as f:
        writer = csv.DictWriter(f, fieldnames=result_dict.keys())
        if is_first:
            writer.writeheader()
        writer.writerow(result_dict)

def classify_and_save(df: pd.DataFrame, model_name: str, output_path: str):
    is_first = not os.path.exists(output_path)  
    
    done_pubids = set()
    if os.path.exists(output_path):
        try:
            done_df = pd.read_csv(output_path)
            done_pubids = set(done_df['pubid'].tolist())
        except Exception as e:
            print(f"⚠️ Could not read existing results: {e}")

    df = df[~df['pubid'].isin(done_pubids)].reset_index(drop=True)

    if df.empty:
        print("✅ All publications are already classified. Nothing to do.")
        return

    for i, row in df.iterrows():
        title = row['itemtitle']
        abstract = re.sub(r'</?p>', '', row['abstract'].replace('\r', '').replace('\n', ' '), flags=re.IGNORECASE)
        abstract = re.sub(r'\s+', ' ', abstract).strip()

        prompt = build_prompt(title, abstract)

        try:
            response = ollama.chat(model=model_name, messages=[{'role': 'user', 'content': prompt}])
            content = response['message']['content']

            relevance_match = re.search(r"Relevance:\s*(Related|Not Related)", content, re.IGNORECASE)
            reason_match = re.search(r"Reason:\s*(.*)", content, re.IGNORECASE)

            relevance = relevance_match.group(1) if relevance_match else "Unclear"
            reason = reason_match.group(1).strip() if reason_match else content.strip()
        except Exception as e:
            relevance = "Error"
            reason = str(e)

        result = {
            'pubid': row['pubid'],
            'relevance': relevance,
            'reason': reason
        }

        append_result_to_csv(result, output_path, is_first)
        is_first = False  

        print(f"[{i+1}/{len(df)}] {relevance} - {reason}")

if __name__ == "__main__":
    if not os.path.exists(input_csv_path):
        print(f"❌ Input file not found: {input_csv_path}")
    else:
        data = load_and_clean_data(input_csv_path)
        classify_and_save(data, desired_model, output_csv_path)
        print(f"✅ Classification complete. Results saved to: {output_csv_path}")
