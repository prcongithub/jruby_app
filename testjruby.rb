class Test
	include Java
	
	Dir["jars/\*.jar"].each { |jar| require jar }
	Dir["jars/mahout/\*.jar"].each { |jar| require jar }
	Dir["jars/mahout/hadoop/\*.jar"].each { |jar| require jar }
	
	ArrayList = java.util.ArrayList;
	
	Properties = java.util.Properties;
 
	Message =  javax.mail.Message;
	RecipientType =  javax.mail.Message::RecipientType;
	MessagingException = javax.mail.MessagingException;
	PasswordAuthentication = javax.mail.PasswordAuthentication;
	Session = javax.mail.Session;
	Transport = javax.mail.Transport;
	InternetAddress = javax.mail.internet.InternetAddress;
	MimeMessage = javax.mail.internet.MimeMessage;
	Authenticator = javax.mail.Authenticator;

	s = String.new

	class MyAuthenticator < Authenticator 
		attr_accessor :username, :password
		
		def getPasswordAuthentication
			return PasswordAuthentication.new(username, password);
		end
	end
	
	def test
		a = ArrayList.new;
		a.add(10);
		p a.get(0)
		
		props = Properties.new();
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.starttls.enable", "true");
		props.put("mail.smtp.host", "smtp.gmail.com");
		props.put("mail.smtp.port", "587");
		
		username = "admin@truespider.com";
		password = "trueSpider123";
 
 		auth = MyAuthenticator.new();
 		auth.username = username;
 		auth.password = password;
		session = Session.getInstance(props,auth);
		
		host = "smtp.gmail.com";
		to = "prashant@truespider.com";
		from = "admin@truespider.com";
		subject = "My First Email";
		messageText = "I am sending a message using the" 
		
		begin
 
			message = MimeMessage.new(session);
			message.setFrom(InternetAddress.new("admin@truespider.com"));
			message.setRecipients(RecipientType::TO,
				InternetAddress.parse("niket@truespider.com"));
			message.setSubject("Testing Subject");
			message.setText("Dear Mail Crawler,\n\n No spam to my email, please!");
 
			Transport.send(message);
 
			puts("Done");
 
		rescue Exception => e 
			throw e
		end
	end
end

Test.new().test()

#Test.new().print_name();

Test.class_eval do
	def print_name
		puts "Prashant"
	end
end

Test.new().print_name();
