SELECT reclada_object.create_subclass('{
    "class": "RecladaObject",
    "attrs": {
        "newClass": "DataSet",
        "properties": {
            "name": {"type": "string"},
            "dataSources": {
                "type": "array",
                "items": {"type": "string"}
            }
        },
        "required": ["name"]
    }
}'::jsonb);