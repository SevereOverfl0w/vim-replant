import neovim
import replant.deps.nrepl_python_client.nrepl as nrepl
import uuid

@neovim.plugin
class Replant(object):

    def __init__(self, nvim):
        self.nvim = nvim

    @neovim.function("G_replant_send_message", sync=True)
    def send_message(self, args):
        c = nrepl.connect("nrepl://localhost:{}".format(args[0]))
        msg = args[1]

        if "id" not in msg:
            msg["id"] = "replant--" + str(uuid.uuid4())

        c.write(msg)

        result = []

        while True:
            m = c.read()
            result.append(m)
            if "status" in m and "done" in m["status"]:
                break

        return result

    @neovim.function("G_replant_send_message_callback", sync=True)
    def send_message_callback(self, args):
        c = nrepl.connect("nrepl://localhost:{}".format(args[0]))
        msg = args[1]
        callback = args[2]

        if "id" not in msg:
            msg["id"] = "replant--" + str(uuid.uuid4())

        c.write(msg)

        while True:
            m = c.read()

            if msg["id"] == m.get("id"):
                self.nvim.call(callback, m)

            if "status" in m and "done" in m["status"]:
                break

        return True
