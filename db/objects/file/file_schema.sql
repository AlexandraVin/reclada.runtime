SELECT reclada_object.create_subclass('{
    "class": "DataSource",
    "attrs": {
        "newClass": "File",
        "properties": {
            "checksum": {"type": "string"},
            "mimeType": {"type": "string"}
        },
        "required": ["checksum", "mimeType"]
    }
}'::jsonb);