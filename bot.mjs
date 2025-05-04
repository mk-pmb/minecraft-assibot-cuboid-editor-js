// -*- coding: utf-8, tab-width: 2 -*-

import mcrProto from 'minecraft-protocol';


function getConfigStr(k, d) {
  const v = (process.env['mcr_' + k] || '').trim();
  return v || d;
}


const McrClient = mcrProto.Client;
const mcrSess = new McrClient({
  host: getConfigStr('host', 'localhost'),
  port: +getConfigStr('port', 25565),
  username: getConfigStr('nick', 'CuboEdit'),
});
mcrSess.connect();
