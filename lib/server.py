from flask import Flask, request, jsonify
from flask_cors import CORS
import logging
import joblib
import os

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

app = Flask(__name__)
CORS(app)  # Enable CORS for all routes

# Dictionary to store our models
models = {}
vectorizer = None

def load_models():
    """Load all saved models and vectorizer"""
    global models, vectorizer
    try:
        logger.info("Loading models...")
        model_dir = 'lib'
        
        # Load vectorizer
        vectorizer = joblib.load(os.path.join(model_dir, 'vectorizer.pkl'))
        
        # Load all models
        models['random_forest'] = joblib.load(os.path.join(model_dir, 'RandomForest_model.pkl'))
        models['gradient_boosting'] = joblib.load(os.path.join(model_dir, 'GradientBoosting_model.pkl'))
        models['naive_bayes'] = joblib.load(os.path.join(model_dir, 'NaiveBayes_model.pkl'))
        models['logistic_regression'] = joblib.load(os.path.join(model_dir, 'LogisticRegression_model.pkl'))
        models['adaboost'] = joblib.load(os.path.join(model_dir, 'AdaBoost_model.pkl'))
        logger.info("All models loaded successfully")
    except Exception as e:
        logger.error(f"Error loading models: {e}")

@app.route('/health', methods=['GET'])
def health_check():
    return jsonify({"status": "healthy"})

@app.route('/analyze', methods=['POST'])
def analyze_email():
    try:
        data = request.get_json()
        email_content = data['email_content']
        
        # Vectorize the email content
        email_vector = vectorizer.transform([email_content])
        
        # Get predictions from all models
        predictions = {model_name: model.predict_proba(email_vector)[0][1] for model_name, model in models.items()}
        
        if not predictions:
            raise ValueError("No models available for prediction")
        
        # Determine if the email is phishing based on the average prediction
        avg_prediction = sum(predictions.values()) / len(predictions)
        is_phishing = avg_prediction > 0.5
        
        response = {
            "is_phishing": bool(is_phishing),
            "probability": avg_prediction,
            "message": "Phishing email detected" if is_phishing else "Email is safe",
            "confidence_level": "high" if avg_prediction > 0.75 else "medium" if avg_prediction > 0.5 else "low",
            "model_predictions": predictions
        }
        return jsonify(response)
    except Exception as e:
        logger.error(f"Error analyzing email: {e}")
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    load_models()
    app.run(host='0.0.0.0', port=5000, debug=True)