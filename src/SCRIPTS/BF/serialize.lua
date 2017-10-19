return {
    filename = "",
    file = nil,
    serialize = function(self, o)
        self.closeFile(self)
        self.openWrite(self)
        io.write(self.file, "return ")
        self.serializeObject(self, o)
        self.closeFile(self)
    end,
    serializeAppend = function(self, o)
        if self.file then
            self.serializeObject(self, o)
        end
    end,
    serializeObject = function(self, o)
        if type(o) == "number" then
            io.write(self.file, o)
        elseif type(o) == "string" then
            io.write(self.file, string.format("%q", o))
        elseif type(o) == "table" then
            io.write(self.file, "{")
            for k,v in pairs(o) do
                io.write(self.file, k, "=")
                self.serializeObject(self, v)
                io.write(self.file, ",")
            end
            io.write(self.file, "}")
        else
            error("cannot serialize a " .. type(o))
        end
    end,
    openWrite = function(self)
        self.open(self, "w")
    end,
    openAppend = function(self)
        self.open(self, "a")
    end,
    open = function(self, mode)
        self.file = io.open(self.filename, mode)
    end,
    append = function(self, o)
        if type(o) == "string" or type(o) == "number" then
            io.write(self.file, o)
        end
    end,
    appendHex = function(self, o)
        if type(o) == "table" then
            for i=1, #(o) do
                self.append(self, string.format("%X ",o[i]))
            end
        elseif type(o) == "number" then
            self.append(self, string.format("%X ", o))
        end
    end,
    closeFile = function(self)
        if self.file then
            io.close(self.file)
        end
    end,
}