return {
    Name = "Hitbox",
    Aliases = {"HT"},
    Description = "Modify HitBox Properties",
    Group = "Admin",
    Args = {
        {
            Type = "htProperty",
            Name = "Properties",
            Description = "System properties Hitbox generator"
        },
        {
            Type = "boolean",
            Name = "Value",
            Description = "Value of the property, True or False"
        }
    }
}