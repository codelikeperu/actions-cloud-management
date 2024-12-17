#!/bin/bash

# Obtener el ID del proyecto
PROJECT_ID=$(curl -s \
  --header "Authorization: Bearer $1" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  https://app.terraform.io/api/v2/organizations/$2/projects | jq -r '.data[] | select(.attributes.name=="'$3'") | .id')

if [ -z "$PROJECT_ID" ]; then
  echo "El proyecto $3 no existe."
  exit 1
fi

# Obtener el ID del equipo
TEAM_ID=$(curl -s \
  --header "Authorization: Bearer $1" \
  --header "Content-Type: application/vnd.api+json" \
  --request GET \
  https://app.terraform.io/api/v2/organizations/$2/teams | jq -r '.data[] | select(.attributes.name=="'$4'") | .id')

if [ -z "$TEAM_ID" ]; then
  echo "El equipo $4 no existe."
  exit 1
fi

# Asignar el equipo al proyecto
curl \
  --header "Authorization: Bearer $1" \
  --header "Content-Type: application/vnd.api+json" \
  --request POST \
  --data '{
    "data": {
      "type": "team-project-assignments",
      "attributes": {
        "team-id": "'$TEAM_ID'",
        "project-id": "'$PROJECT_ID'"
      }
    }
  }' \
  https://app.terraform.io/api/v2/team-project-assignments