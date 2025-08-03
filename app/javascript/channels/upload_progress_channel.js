import consumer from "channels/consumer"

consumer.subscriptions.create(
  { 
    channel: "UploadProgressChannel", 
    room: document.body.dataset.room || "default" 
  },
  {
    connected() {
      console.log("Connected to UploadProgressChannel");
    },

    disconnected() {
      console.log("Disconnected from UploadProgressChannel");
    },

    received(data) {
      console.log("Received:", data);
    }
  }
);