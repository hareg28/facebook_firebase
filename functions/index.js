// Firebase Cloud Functions for sending email notifications
// To deploy: firebase deploy --only functions

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

// You can use SendGrid, Mailgun, or any other email service
// For this example, we'll use nodemailer with Gmail (you need to set up OAuth2 or use App Password)
const nodemailer = require('nodemailer');

// Configure your email service here
// For production, use environment variables: functions.config().email.user
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: functions.config().email?.user || 'your-email@gmail.com',
    pass: functions.config().email?.pass || 'your-app-password',
  },
});

// Triggered when a new email notification is added to Firestore
exports.sendEmailNotification = functions.firestore
  .document('email_notifications/{notificationId}')
  .onCreate(async (snap, context) => {
    const notificationData = snap.data();
    
    // Only process pending notifications
    if (notificationData.status !== 'pending') {
      return null;
    }

    try {
      const mailOptions = {
        from: functions.config().email?.user || 'your-email@gmail.com',
        to: notificationData.userEmail,
        subject: notificationData.subject,
        text: notificationData.body,
        html: `
          <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto;">
            <h2 style="color: #1877F2;">${notificationData.subject}</h2>
            <p style="white-space: pre-line;">${notificationData.body}</p>
            <hr style="border: none; border-top: 1px solid #eee; margin: 20px 0;">
            <p style="color: #666; font-size: 12px;">
              This is an automated message from Facebook. Please do not reply to this email.
            </p>
          </div>
        `,
      };

      // Send email
      await transporter.sendMail(mailOptions);

      // Update notification status to sent
      await snap.ref.update({
        status: 'sent',
        sentAt: admin.firestore.FieldValue.serverTimestamp(),
      });

      console.log(`Email sent successfully to ${notificationData.userEmail}`);
      return null;
    } catch (error) {
      console.error('Error sending email:', error);
      
      // Update notification status to failed
      await snap.ref.update({
        status: 'failed',
        error: error.message,
        failedAt: admin.firestore.FieldValue.serverTimestamp(),
      });
      
      return null;
    }
  });

