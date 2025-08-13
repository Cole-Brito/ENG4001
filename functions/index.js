const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteExpiredGuests = functions.pubsub.schedule('every 1 hours').onRun(async (context) => {
  const now = new Date().toISOString();
  const guestsRef = admin.firestore().collection('guests');
  const expiredGuests = await guestsRef.where('expiresAt', '<', now).get();

  const batch = admin.firestore().batch();
  expiredGuests.forEach(doc => batch.delete(doc.ref));
  await batch.commit();

  console.log(`Deleted ${expiredGuests.size} expired guests.`);
  return null;
});
