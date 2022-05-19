const functions = require("firebase-functions");
const admin = require("firebase-admin");



admin.initializeApp();



exports.sendVerify = functions.https.onRequest(async (req, res) => { 

    let uid = req.query.uid.split("/")[0];

    await admin
        .firestore()
        .collection('users').doc(uid).update({
      'isAgent': true,

        });
    
    res.send('success');

});


exports.notifocations = functions.firestore
    .document('userData/{userId}/notifications/{notification}')
    .onCreate(async (snap, context) => {
        console.log('----------------start function--------------------')

        const doc = snap.data()
        console.log(doc)
        const message=doc.message;
        const uid = context.params.userId;
        




        admin
        .firestore()
        .collection('users')
        .where('userId', '==', uid)
        .get()
        .then(querySnapshot => {
          querySnapshot.forEach(userTo => {
            console.log(`Found user to: ${userTo.data().fullName}`)
           
            // Get info user from (sent)
          
                  const payload = {
  
                    notification: {
                      id:'/notifications/'+doc.id,
                      title: 'AutoConnect',
                      body: message,
                      badge: '1',
                      sound: 'default'
                    },
                    data: {
                      profilePic: userTo.data().profilePic,
                      
                    }
                  }
                  // Let push to the target device
                  admin
                    .messaging()
                    .sendToDevice(userTo.data().pushToken, payload)
                    .then(response => {
                      console.log('Successfully sent message:', response)
                    })
                    .catch(error => {
                      console.log('Error sending message:', error)
                    })
                })
              })
          
          
          
        
      return null
    });



 
exports.sendNotification = functions.firestore
  .document('chats/{chatRoom}/messages/{message}')
  .onCreate(async (snap, context) => {
    console.log('----------------start function--------------------')

    const doc = snap.data()
    console.log(doc)

    const idFrom = doc.sender
    const idTo = doc.to
    const contentMessage = doc.message


    // Get push token user to (receive)
    admin
      .firestore()
      .collection('users')
      .where('userId', '==', idTo)
      .get()
      .then(querySnapshot => {
        querySnapshot.forEach(userTo => {
          console.log(`Found user to: ${userTo.data().fullName}`)
         
          // Get info user from (sent)
          admin
            .firestore()
            .collection('users')
            .where('userId', '==', idFrom)
            .get()
            .then(querySnapshot2 => {
              querySnapshot2.forEach(userFrom => {
                console.log(`${userFrom.data().fullName}`)
                const payload = {

                  notification: {
                    id:'/chat-screen',
                    title: `${userFrom.data().fullName}`,
                    body: contentMessage,
                    badge: '1',
                    sound: 'default'
                  },
                  data: {
                    profilePic: userFrom.data().profilePic,
                    
                  }
                }
                // Let push to the target device
                admin
                  .messaging()
                  .sendToDevice(userTo.data().pushToken, payload)
                  .then(response => {
                    console.log('Successfully sent message:', response)
                  })
                  .catch(error => {
                    console.log('Error sending message:', error)
                  })
              })
            })
        })
        
        
      })
    return null
  })
