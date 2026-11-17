#!/bin/bash
# Part H: delete the two resources that live outside the stack.
# Run ONCE, when completely finished. Do not run between rebuilds.
set -u

export $(grep -v '^#' .env | xargs)

echo "This will delete:"
echo "  SNS topic:     $SNS_TOPIC_ARN"
echo "  SSM parameter: $GEMINI_KEY_PARAM"
read -r -p "Type DELETE to continue: " answer
[ "$answer" = "DELETE" ] || { echo "Cancelled."; exit 1; }

echo "== Deleting SNS topic (this also removes its subscriptions) =="
aws sns delete-topic --topic-arn "$SNS_TOPIC_ARN" --region "$AWS_REGION" \
  && echo "Topic deleted." || echo "Topic not deleted (already gone, or permission missing)."

echo "== Deleting SSM parameter =="
aws ssm delete-parameter --name "$GEMINI_KEY_PARAM" --region "$AWS_REGION" \
  && echo "Parameter deleted." || echo "Parameter not deleted (already gone, or permission missing)."

echo "Done. Now run the four listings from Part H to prove nothing is left."
