import mlflow
import pandas as pd
from sklearn.ensemble import RandomForestClassifier
from sklearn.model_selection import train_test_split
from sklearn.metrics import accuracy_score, f1_score, classification_report
from databricks.sdk import WorkspaceClient


def bin_quality(score):
    if score <= 4:
        return "low"
    elif score <= 6:
        return "medium"
    else:
        return "high"


def load_data():
    w = WorkspaceClient()
    result = w.statement_execution.execute_statement(
        warehouse_id="cfe55031a9b649cb",
        statement="SELECT * FROM fp_hack.b2_int__martin.fct_wine_quality",
        wait_timeout="30s",
    )
    columns = [col.name for col in result.manifest.schema.columns]
    return pd.DataFrame(result.result.data_array, columns=columns)


def main():
    df = load_data()
    df = df.apply(pd.to_numeric, errors="coerce")

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

    mlflow.set_tracking_uri("databricks")
    mlflow.set_experiment("/Users/martin.oldentoft@finitypeople.se/wine_quality")

    with mlflow.start_run(run_name="random_forest_multiclass"):
        model = RandomForestClassifier(
            n_estimators=100, random_state=42, class_weight="balanced"
        )
        model.fit(X_train, y_train)

        y_pred = model.predict(X_test)
        accuracy = accuracy_score(y_test, y_pred)
        f1 = f1_score(y_test, y_pred, average="macro")

        mlflow.log_param("n_estimators", 100)
        mlflow.log_param("class_weight", "balanced")
        mlflow.log_param("features", ", ".join(features))
        mlflow.log_param("quality_bins", "low(3-4), medium(5-6), high(7-8)")
        mlflow.log_metric("accuracy", accuracy)
        mlflow.log_metric("f1_macro", f1)

        mlflow.sklearn.log_model(
            model,
            "wine_model",
            input_example=X_test.head(1),
            registered_model_name="fp_hack.b2_int__martin.wine_quality_model",
        )

        print(f"Accuracy: {accuracy:.3f}")
        print(f"F1 Macro: {f1:.3f}")
        print()
        print(classification_report(y_test, y_pred))


if __name__ == "__main__":
    main()
