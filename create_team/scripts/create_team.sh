
curl \
    --header "Authorization: Bearer ${inputs.terraform_token}" \
    --header "Content-Type: application/vnd.api+json" \
    --request POST \
    --data '{
        "data": {
            "type": "teams",
            "attributes": {
                "name": "'"${inputs.team_name}"'"
            }
        }
    }' \
    https://app.terraform.io/api/v2/organizations/${inputs.organization}/teams
