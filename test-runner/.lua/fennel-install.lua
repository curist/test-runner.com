local fennel = require("fennel")

fennel.path = fennel.path .. ";/zip/.fnl/?.fnl"
fennel.path = fennel.path .. ";/zip/?.fnl"

fennel.install({ correlate = true })
