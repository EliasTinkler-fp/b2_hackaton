import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay, classification_report
from databricks.sdk import WorkspaceClient


def load_data():
    w = WorkspaceClient()
    result = w.statement_execution.execute_statement(
        warehouse_id="cfe55031a9b649cb",
        statement="SELECT * FROM fp_hack.b2_int__martin.fct_wine_quality",
        wait_timeout="30s",
    )
    columns = [col.name for col in result.manifest.schema.columns]
    df = pd.DataFrame(result.result.data_array, columns=columns)
    return df.apply(pd.to_numeric, errors="coerce")


def bin_quality(score):
    if score <= 4:
        return "low"
    elif score <= 6:
        return "medium"
    else:
        return "high"


def main():
    df = load_data()
    df["quality_class"] = df["quality_score"].apply(bin_quality)

    features = [
        "fixed_acidity", "volatile_acidity", "citric_acid", "residual_sugar",
        "chlorides", "free_sulfur_dioxide", "total_sulfur_dioxide", "density",
        "ph", "sulphates", "alcohol",
    ]
    X = df[features]
    y = df["quality_class"]

    X_train, X_test, y_train, y_test = train_test_split(
        X, y, test_size=0.2, stratify=y, random_state=42
    )

    model = RandomForestClassifier(
        n_estimators=100, random_state=42, class_weight="balanced"
    )
    model.fit(X_train, y_train)
    y_pred = model.predict(X_test)

    fig, axes = plt.subplots(2, 2, figsize=(14, 11))
    fig.suptitle("Wine Quality Classification — Random Forest Results", fontsize=16, fontweight="bold")

    # 1. Class distribution
    ax = axes[0, 0]
    class_order = ["low", "medium", "high"]
    colors = ["#e74c3c", "#3498db", "#2ecc71"]
    counts = df["quality_class"].value_counts().reindex(class_order)
    bars = ax.bar(class_order, counts, color=colors, edgecolor="white", linewidth=1.5)
    for bar, count in zip(bars, counts):
        ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 10,
                str(count), ha="center", va="bottom", fontweight="bold", fontsize=12)
    ax.set_title("Class Distribution", fontsize=13, fontweight="bold")
    ax.set_xlabel("Quality Class")
    ax.set_ylabel("Count")
    ax.set_ylim(0, max(counts) * 1.15)

    # 2. Confusion matrix
    ax = axes[0, 1]
    cm = confusion_matrix(y_test, y_pred, labels=class_order)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=class_order)
    disp.plot(ax=ax, cmap="Blues", colorbar=False)
    ax.set_title("Confusion Matrix", fontsize=13, fontweight="bold")

    # 3. Feature importance
    ax = axes[1, 0]
    importances = model.feature_importances_
    sorted_idx = np.argsort(importances)
    ax.barh([features[i] for i in sorted_idx], importances[sorted_idx], color="#3498db", edgecolor="white")
    ax.set_title("Feature Importance", fontsize=13, fontweight="bold")
    ax.set_xlabel("Importance")

    # 4. Per-class metrics
    ax = axes[1, 1]
    report = classification_report(y_test, y_pred, labels=class_order, output_dict=True, zero_division=0)
    metrics = ["precision", "recall", "f1-score"]
    x_pos = np.arange(len(class_order))
    width = 0.25
    metric_colors = ["#e74c3c", "#f39c12", "#2ecc71"]
    for i, metric in enumerate(metrics):
        values = [report[c][metric] for c in class_order]
        bars = ax.bar(x_pos + i * width, values, width, label=metric.capitalize(), color=metric_colors[i], edgecolor="white")
        for bar, val in zip(bars, values):
            if val > 0:
                ax.text(bar.get_x() + bar.get_width() / 2, bar.get_height() + 0.02,
                        f"{val:.2f}", ha="center", va="bottom", fontsize=9)
    ax.set_xticks(x_pos + width)
    ax.set_xticklabels(class_order)
    ax.set_ylim(0, 1.15)
    ax.set_title("Per-Class Metrics", fontsize=13, fontweight="bold")
    ax.legend(loc="upper right")

    plt.tight_layout(rect=[0, 0, 1, 0.95])
    output_path = "wine_quality_results.png"
    plt.savefig(output_path, dpi=150, bbox_inches="tight")
    print(f"Saved to {output_path}")
    plt.close()


if __name__ == "__main__":
    main()
