Map<String, dynamic> recommendationQuestionAndAns = {
  "skincare_history_questions": {
    "questions": [
      {
        "question": "What is your age?",
        "options": ["0-18 Years", "Above 18"]
      },
      {
        "question": "What is your gender?",
        "options": ["Male", "Female"]
      },
      {
        "question": "Are you pregnant?",
        "options": ["Yes", "No"]
      },
      {
        "question": "Are you using retinol based products right now?",
        "options": ["Yes", "No"]
      },
      {
        "question": "Do you follow basic skincare?",
        "options": [
          "No",
          "Yes, for more than one month",
          "Yes, for more than 6 month",
          "Yes, for more than 1 year"
        ]
      },
      {
        "question": "What of the following skincare you follow everyday?",
        "options": [
          "Cleanser",
          "Moisturizer",
          "Spf",
          "Serum",
          "Toner",
          "Night cream",
          "Eye cream"
        ]
      },
      {
        "question": "How sensitive is your skin?",
        "options": ["No", "Somewhat sensitive", "Very sensitive"]
      },
      {
        "question":
            "Do your skin have burning, tingling sensation, redness for no obvious reasons?",
        "options": ["Yes", "No"]
      },
      {
        "question": "Does skincare products easily irritate your skin?",
        "options": ["Never", "Rarely", "Sometimes", "Often"]
      },
    ]
  },
  "sensitivity_related_questions": {
    "questions": [
      {
        "question":
            "Do you experience redness or irritation after using skincare products?",
        "options": ["Yes", "No", "Sometimes"]
      },
      {
        "question": "Have you ever been diagnosed with rosacea?",
        "options": ["Yes", "No"]
      },
      {
        "question":
            "Do you experience stinging or burning after using skincare products?",
        "options": ["Yes", "No", "Sometimes"]
      }
    ]
  },
  "skincare_goal_questions": {
    "questions": [
      {
        "question": "What is your primary skincare concern?",
        "options": [
          "Acne",
          "Anti-aging",
          "Closed comedones( blackheads, whiteheads)",
          "Hyperpigmentation",
          "Dullness",
          "Dehydrated skin"
        ]
      },
      {
        "question": "What is your skin type?",
        "options": [
          "Oily",
          "Combination",
          "Oily to combination",
          "Dry",
          "Normal",
          "I don't know"
        ]
      },
      {
        "question": "How does your skin feel in the morning?",
        "options": [
          "Tight and dry",
          "Comfortable",
          "Oily",
          "T zone oily , U zone dry or normal",
          "Not sure"
        ]
      },
      {
        "question": "After shower your skin feels",
        "options": [
          "Tight and dry",
          "Nothing particular",
          "Oily",
          "T zone oily , U zone dry or normal",
          "Never noticed"
        ]
      },
      {
        "question": "How your skin feels few hours after using moisturizer ?",
        "options": [
          "Dry",
          "Oily",
          "Dry in some area, oily in some area",
          "I don’t use a moisturizer"
        ]
      },
      {
        "question": "Do you have damaged skin barrier?",
        "options": ["Yes", "No"]
      }
    ]
  },
  "related_questions_based_on_primary_concern": {
    "acne": {
      "questions": [
        {
          "question":
              "Did you always have acne or did you recently start having them?",
          "options": [
            "I always have had acne",
            "I always have had acne but recently it got worse",
            "I always had clear skin but recently started getting acne",
            "I am not sure"
          ]
        },
        {
          "question": "How often do you see pimple on your face?",
          "options": ["Daily", "Weekly", "Monthly", "Sometimes"]
        },
        {
          "question": "Do you see more pimple on your period?",
          "options": ["Yes", "No", "Not sure"]
        },
        {
          "question": "How often do you see red big inflammed pimples?",
          "options": ["Often", "Never", "Sometimes"]
        },
        {
          "question": "Are you under any prescription?",
          "options": ["Yes", "No"]
        }
      ]
    },
    "anti_aging": {
      "questions": [
        {
          "question": "Do you see wrinkles when your face is at rest?",
          "options": ["Yes", "No", "Yes but only on eye area"],
          "images": [
            "assets/recommendation/aging_1_1.png",
            "assets/recommendation/aging_1_2.png",
            "assets/recommendation/aging_1_3.png"
          ]
        },
        {
          "question":
              "Are you concerned about your skin elasticity, wrinkled or sagging?",
          "options": [
            "Not concerned",
            "A little concerned",
            "Somewhat concerned",
            "Very concerned"
          ],
        },
      ]
    },
    "blackheads_whiteheads": {
      "questions": [
        {
          "question":
              "Do you have open (blackhead) or closed (whitehead) comedones?",
          "options": ["Blackheads", "Whiteheads", "Both", "Not sure"],
          "images": [
            "assets/recommendation/aging_3_1.png",
            "assets/recommendation/aging_3_2.png",
            "assets/recommendation/aging_3_3.png",
            "assets/recommendation/aging_3_4.png"
          ]
        },
        {
          "question": "Where do you have the most amount of mini bumps?",
          "options": [
            "Forehead",
            "T zone",
            "All over the face",
            "None of the above"
          ]
        },
      ]
    },
    "hyperpigmentation": {
      "questions": [
        {
          "question":
              "Do you get dark spots or discoloration after your pimples?",
          "options": ["Yes", "No"],
        },
        {
          "question":
              "What types of dark spots or pigmentation you have on your skin?",
          "options": [
            "Large dark patches",
            "Melasma",
            "Freckles",
            "PDL",
            "Acne spot",
            "No spots"
          ],
          "images": [
            "assets/recommendation/pigmantation_2_1.png",
            "assets/recommendation/pigmantation_2_2.png",
            "assets/recommendation/pigmantation_2_3.png",
            "assets/recommendation/pigmantation_2_4.png",
            "assets/recommendation/pigmantation_2_5.png",
            "assets/recommendation/pigmantation_2_6.png",
          ]

        },
        {
          "question":
              "Which part of skin contain hyperpigmentation or uneven skin tone?",
          "options": [
            "Mouth area",
            "Acne spots",
            "Forehead",
            "I don’t have any hyperpigmentation"
          ],
          "images": [
            "assets/recommendation/pigmantation_3_1.png",
            "assets/recommendation/pigmantation_3_2.png",
            "assets/recommendation/pigmantation_3_3.png",
            "assets/recommendation/pigmantation_3_4.png",
            "assets/recommendation/pigmantataion_3_5.png",
          ]
        },
      ]
    },
    "dullness": {
      "questions": [
        {
          "question": "Does your skin look dull and tired?",
          "options": ["Yes", "No", "I am not sure"]
        }
      ]
    },
    "dehydrated_skin": {
      "questions": [
        {
          "question":
              "Does your skin looks more dehydrated even though it produces more oil lately?",
          "options": ["Yes", "No", "I am not sure"]
        },
        {
          "question":
              "Do you feel that even though you use moisturizer you skin is tightening up from the inside?",
          "options": [
            "Yes",
            "No , skin looks and feels hydrated",
            "I am not sure"
          ]
        }
      ]
    }
  }
};
