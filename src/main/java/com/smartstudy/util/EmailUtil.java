   
    package com.smartstudy.util;

    import jakarta.mail.Authenticator;
    import jakarta.mail.Message;
    import jakarta.mail.PasswordAuthentication;
    import jakarta.mail.Session;
    import jakarta.mail.Transport;
    import jakarta.mail.internet.InternetAddress;
    import jakarta.mail.internet.MimeMessage;

    import java.util.Properties;

    public class EmailUtil {

        private static final String SMTP_HOST = "smtp.gmail.com";
        private static final String SMTP_PORT = "587";

        private static final String FROM_EMAIL = "papucmihai022@gmail.com";
        private static final String APP_PASSWORD = "jskk spac elih tinl";

        public static void sendEmail(String to, String subject, String body) throws Exception {
            Properties props = new Properties();

            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(
                    props,
                    new Authenticator() {
                        @Override
                        protected PasswordAuthentication getPasswordAuthentication() {
                            return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
                        }
                    }
            );

            Message message = new MimeMessage(session);

            message.setFrom(new InternetAddress(FROM_EMAIL, "SmartStudy AI"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(subject);
            message.setText(body);

            Transport.send(message);
        }
    }