const bencoder = require('streaming-bencode2');
const bencode = require('bencode').encode;
const uuid = require('uuid/v4');
const { Socket } = require('net');
//
// // If `Plugin` decorator can be called with options
// // @Plugin({dev: true})
// class ReplantPlugin {
//
//   // @Function('G_replant_send_message_js', {sync: true})
//   send_message(args, done) {
//     let socket = new Socket()
//     socket.connect(args[0])
//     msg = args[1]
//
//     if !("id" in msg) {
//       msg.id = "replant--" + uuid();
//     }
//
//     msgs = []
//
//     socket.pipe(bencoder.transform())
//       .on('data', function(d) {
//         if (d.id == msg.id) {
//           msgs = msgs.concat(d);
//
//           if (d.status.indexOf('done') > -1) {
//             done(msgs);
//             socket.end();
//           }
//         }
//       });
//   }
// }
//
// Function('G_replant_send_message_js', {sync: true})(ReplantPlugin.prototype.send_message)
//
// module.exports = Plugin({dev: true})(ReplantPlugin)
//
// const { Plugin, Command } = require('neovim')
//
// class TestPlugin {
// 	splitV() {
// 		this.nvim.command('vsplit')
// 	}
// }
//
// Command('Vsplit')(TestPlugin.prototype.splitV)
//
// module.exports = Plugin({ dev: true })(TestPlugin)

function syncReturn(args) {

  let socket = new Socket();

  let [port, msg] = args;

  if (!("id" in msg)) {
    msg.id = "replant--" + uuid();
  }

  let msgs = []

  let p = new Promise(function(resolve, reject){
    socket
      .pipe(bencoder.transformer())
      .on('error', reject)
      .on('data', function(d) {
        if (d.id == msg.id) {
          msgs = msgs.concat(d);

          if (("status" in d) && d.status.indexOf('done') > -1) {
            socket.end();
            resolve(msgs);
          }
        }

      });
  })

  socket.connect(port)
  socket.write(bencode(msg))

  return p
}

function asyncCallback(args) {

  let socket = new Socket();
  let [port, msg, callback] = args
  let nvim = this.nvim

  if (!("id" in msg)) {
    msg.id = "replant--" + uuid();
  }

  let p = new Promise(function(resolve, reject){
    socket
      .pipe(bencoder.transformer())
      .on('error', reject)
      .on('data', function(d) {
        if (d.id == msg.id) {
          nvim.call(callback, [d])
            .then(function(res_){
              if (("status" in d) && d.status.indexOf('done') > -1) {
                socket.end();
                resolve(true);
              }
            })
            .catch(reject)
        }
      });
  })

  socket.connect(port)
  socket.write(bencode(msg))

  return p
}

module.exports = (plugin) => {
  plugin.registerFunction('G_replant_send_message', [plugin, syncReturn], {sync: true});
  plugin.registerFunction('G_replant_send_message_callback', [plugin, asyncCallback], {sync: true});
};
