#!/bin/bash
EXISTING_PROJECT=$(curl -s \
  --header "Authorization: Bearer ${{ inputs.terraform_token }}" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  https://app.terraform.io/api/v2/organizations/${{ inputs.organization }}/projects | jq -r '.data[] | select(.attributes.name=="${{ inputs.project_name }}") | .id')

if [ -n "$EXISTING_PROJECT" ]; then
  echo "El proyecto ${{ inputs.project_name }} ya existe con ID: $EXISTING_PROJECT"
else
  # Crear el proyecto si no existe
  curl -s \
    --header "Authorization: Bearer ${{ inputs.terraform_token }}" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data '{
      "data": {
        "type": "projects",
        "attributes": {
          "name": "'${{ inputs.project_name }}'"
        }
      }
    }' \
    https://app.terraform.io/api/v2/organizations/${{ inputs.organization }}/projects
  echo "Proyecto ${{ inputs.project_name }} creado exitosamente"
fi