import neovim

from urllib.request import urlopen
import json

@neovim.plugin
class Replant(object):

    def __init__(self, nvim):
        self.nvim = nvim

    @neovim.function("G_replant_http_json", sync=True)
    def http_json(self, args):
        res = urlopen(args[0])
        return json.loads(res.read().decode('utf8'))
