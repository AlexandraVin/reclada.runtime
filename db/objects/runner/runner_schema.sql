SELECT reclada_object.create_subclass('{
    "class": "Job",
    "attrs": {
        "newClass": "Runner",
        "properties": {
            "environment": {
                "type": "string",
                "pattern": "[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}"
            },
            "status": {
                "type": "string",
                "enum ": [
                    "up",
                    "down"
                ]
            }
        },
        "required": ["environment", "status"]
    }
}'::jsonb);