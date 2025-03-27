
local mmdb = require('geoip2')


local db = mmdb.open('/var/lib/haproxy/geo.bin')


function get_isp(txn)
    local ip

    ip = txn.f:hdr("CF-Connecting-IP")

    if not ip or ip == "" then
        ip = txn.f:hdr("X-Forwarded-For")
    end

    if not ip or ip == "" then
        ip = txn.sf:src()
    end

    local result, err = db:lookup(ip)

    if not result then
        txn:set_var("txn.client_isp", "Unknown")
        return
    end

    if result.isp then
        txn:set_var("txn.client_isp", result.isp)
    else
        txn:set_var("txn.client_isp", "Unknown")
    end

    local mac_cookie = txn.f:cookie("mac")


    if mac_cookie and mac_cookie ~= "" then
        txn:set_var("txn.mac", mac_cookie)
        txn:set_var("txn.has_mac", "true")
    else
        txn:set_var("txn.mac", "none")
        txn:set_var("txn.has_mac", "false")
    end
end

core.register_action("get_isp_action", {"http-req"}, get_isp)