HRP.DatabaseType = {
    BYTE = 0,
    BOOL = 1,
    STR = 2,
    UL = 3,
    L = 4,
    US = 5,
    S = 6,
    D = 7,
    F = 8
}

function HRP.Database(fileName)
    return {
        fileName = fileName,
        data = {}
    }
end

function HRP.ReadVariable(database, type, id, default)
    default = default or 0

    for i = 1, #database.data do
        if database.data[i].type == type then
            if database.data[i].id == id then
                return database.data[i].v
            end
        end
    end

    return default
end

function HRP.WriteVariable(database, type, id, v)
    for i = 1, #database.data do
        if database.data[i].type == type then
            if database.data[i].id == id then
                database.data[i].v = v

                return
            end
        end
    end

    table.insert(database.data, {type = type, id = id, v = v})
end

function HRP.LoadData(database)
    local f = file.Open(database.fileName, "rb", "DATA")

    if !f then
        return database
    end

    if !f:Size() then
        f:Close()

        return database
    end

    repeat
        local type = f:ReadByte()
        local id = f:Read(f:ReadULong())
        local v = nil

        if type == HRP.DatabaseType.BYTE then
            v = f:ReadByte()
        elseif type == HRP.DatabaseType.BOOL then
            v = f:ReadBool()
        elseif type == HRP.DatabaseType.STR then
            v = f:Read(f:ReadULong())
        elseif type == HRP.DatabaseType.UL then
            v = f:ReadULong()
        elseif type == HRP.DatabaseType.L then
            v = f:ReadLong()
        elseif type == HRP.DatabaseType.US then
            v = f:ReadUShort()
        elseif type == HRP.DatabaseType.S then
            v = f:ReadShort()
        elseif type == HRP.DatabaseType.D then
            v = f:ReadDouble()
        elseif type == HRP.DatabaseType.F then
            v = f:ReadFloat()
        end

        table.insert(database.data, {type = type, id = id, v = v})
    until f:Read(2) != "\r\n"

    f:Close()

    return database
end

function HRP.SaveData(database)
    local f = file.Open(database.fileName, "wb", "DATA")

    if !f then
        if file.Exists(database.fileName, "DATA") then
            return false
        end

        file.Write(database.fileName, "")

        return HRP.SaveData(database)
    end

    for i = 1, #database.data do
        f:WriteByte(database.data[i].type)
        f:WriteULong(string.len(database.data[i].id))
        f:Write(database.data[i].id)

        if database.data.type == HRP.DatabaseType.BYTE then
            f:WriteByte(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.BOOL then
            f:WriteBool(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.STR then
            f:WriteULong(string.len(database.data[i].v))
            f:Write(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.UL then
            f:WriteULong(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.L then
            f:WriteLong(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.US then
            f:WriteUShort(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.S then
            f:WriteShort(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.D then
            f:WriteDouble(database.data[i].v)
        elseif database.data.type == HRP.DatabaseType.F then
            f:WriteFloat(database.data[i].v)
        end

        f:Write("\r\n")
    end

    f:Flush()
    f:Close()

    return true
end