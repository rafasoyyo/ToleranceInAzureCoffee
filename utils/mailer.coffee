###
# @memberOf Node
# @method app.definition
###

###
# Node utils
# @namespace Node.utils
# @module Mailer
# @see rafa
###



###
		HOW TO USE IT.

		Configure:
		On this file you have to configure path and auth.

		Import module:
		var mailer = require('./mailer');

		Use module:
		mailer(
			{
				to      : List or receivers. Can be string with one or more emais, array of emails or array or objects with a key 'email'
				subject : Text for subject
				template: Template name with extension. Can be jade or html
				info    : Info to fill the templates. Can be an object or array of objects so each object will fill a different template.
				text    : Plain text to send if HTML is not allowed or not supported.
				custom  : Optional (true - false), default false. when to use array of info to fill
			},
			function(err, result){ callback }
		)
###

# REQUERIMENTS
nodemailer 	= require('nodemailer')
swig 		= require('swig')
jade 		= require('jade')
colors		= require('colors')

# CONFIGURATIONS
path = './public/mails/'
auth =
	service: 'gmail'
	tls: rejectUnauthorized: false
	auth:
		user: 'rafaelhn.iti@gmail.com'
		pass: 'notengo000'

# REXEXP TO VALIDATE EMAILS
emailRegexp = /^(([^()[\]\\.,;:\s@“]+(\.[^()[\]\\.,;:\s@"]+)*)|(".+"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zAZ]{2,}))$/

# CREATE TRANSPORT
transporter = nodemailer.createTransport(auth)

# VERIFY TRANSPORT CONNECTION
transporter.verify (err, success) ->
	if err
		console.log colors.red('Nodemalier error: ', err)
	return
###
# afeccionModel
# @memberOf Mailer
# @method afeccionSchema
# @example
		mailer(
			{
				to      : List or receivers. Can be string with one or more emais, array of emails or array or objects with a key 'email'
				subject : Text for subject
				template: Template name with extension. Can be jade or html
				info    : Info to fill the templates. Can be an object or array of objects so each object will fill a different template.
				text    : Plain text to send if HTML is not allowed or not supported.
				custom  : Optional (true - false), default false. when to use array of info to fill
			},
			function(err, result){ callback }
		)
###
get_receivers = (receivers, callback) ->
	emails = []
	valid = []
	invalid = []
	if typeof receivers == 'string'
		if receivers.indexOf(',') == -1 then emails = [ receivers ]
		else emails = receivers.replace(' ', '').split(',')
	else
		if typeof receivers == 'object'
			if typeof receivers[0] == 'string' then emails = receivers
			else emails.push receiver.email for reveiver in reveivers

	for email in emails
		if email.match(emailRegexp) isnt null then valid.push emails[j]
		else invalid.push emails[j]

	callback invalid, valid

# EMAIL SENDER
sender = (options, callback) ->
	transporter.sendMail {
		from 	: options.from
		to 		: options.to
		subject : options.subject
		text 	: options.text
		html 	: options.html
	}, callback

# PREPARE EMAIL VARIABLES AND VALIDATE THEM
sendmail = (options, callback) ->
	if not options.to 		then return callback('No direction to send.', null)
	if not options.subject 	then return callback('No subject defined.', null)
	if not options.template then return callback('No templates especified.', null)
	if options.custom and not options.info.length return callback('if custom is set to true, then info should be an array.', null)

	get_receivers options.to, (err, emails) ->

		if err.length
			console.log colors.red(err + ' are not a valid emails!' + '\n' + 'Emails will not be send!!!')

		if emails.length
			if options.custom
				e = 0
				while e < emails.length
					sender {
						from: options.from or 'rafaelhn.iti@gmail.com'
						to: emails[e]
						subject: options.subject
						text: options.text
						html: if options.template.match('.html') != null then swig.renderFile(path + options.template, options.info[e]) else jade.renderFile(path + options.template, options.info[e])
					}, callback
					e++
			else
				sender {
					from: options.from or 'rafaelhn.iti@gmail.com'
					to: emails
					subject: options.subject
					text: options.text
					html: if options.template.match('.html') != null then swig.renderFile(path + options.template, options.info) else jade.renderFile(path + options.template, options.info)
				}, callback
		return
	return

module.exports = sendmail