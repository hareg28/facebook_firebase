# Email Notification Setup Guide

This app sends email notifications when users sign in, sign up, or sign out. The email notifications are queued in Firestore and processed by Firebase Cloud Functions.

## How It Works

1. When a user signs in/up/out, the app creates a document in the `email_notifications` collection in Firestore
2. A Cloud Function listens for new documents and sends the email
3. The notification status is updated to 'sent' or 'failed'

## Setup Options

### Option 1: Firebase Cloud Functions (Recommended)

1. **Install Firebase CLI** (if not already installed):
   ```bash
   npm install -g firebase-tools
   ```

2. **Initialize Functions** (if not already done):
   ```bash
   cd functions
   npm install
   ```

3. **Configure Email Service**:
   
   For Gmail:
   - Go to your Google Account settings
   - Enable 2-Factor Authentication
   - Generate an App Password
   - Set the email configuration:
     ```bash
     firebase functions:config:set email.user="your-email@gmail.com" email.pass="your-app-password"
     ```

   For SendGrid (Recommended for Production):
   - Sign up at https://sendgrid.com
   - Get your API key
   - Update `functions/index.js` to use SendGrid instead of nodemailer

4. **Deploy Functions**:
   ```bash
   firebase deploy --only functions
   ```

### Option 2: Use a Third-Party Email Service API

You can modify the email service to call an HTTP API directly from the Flutter app:

1. Sign up for a service like:
   - EmailJS (https://www.emailjs.com/)
   - SendGrid
   - Mailgun
   - AWS SES

2. Update `lib/services/email_service.dart` to make HTTP requests to the API

### Option 3: Use Firebase Extensions

1. Go to Firebase Console → Extensions
2. Install "Trigger Email" extension
3. Configure it to send emails from the `email_notifications` collection

## Testing

1. Sign in/up/out with a Google account
2. Check Firestore console for documents in `email_notifications` collection
3. Check the email inbox of the user
4. Check Cloud Functions logs: `firebase functions:log`

## Notes

- Email notifications are stored in Firestore under `email_notifications` collection
- Each notification has: type, userEmail, userName, userId, subject, body, status
- Status can be: 'pending', 'sent', or 'failed'
- The Cloud Function automatically processes pending notifications

