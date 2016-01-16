module.exports = (async, config) ->

  router = (params, callback) ->
    request = require('request')
    response = ''

    if params
      request 'https://dandpb.fwd.wf/devices?' + params, (error, response, body) ->
        console.log 'https://dandpb.fwd.wf/devices?' + params
        if (!error && response.statusCode == 200)
          console.log body
          callback body

    else
      request 'https://dandpb.fwd.wf/devices', (error, response, body) ->
        if (!error && response.statusCode == 200)
          callback body

  getAllDevices = (callback) ->
    router null, (body) ->
      console.log body
      callback body

  getDeviceByOs = (os, callback) ->
    params = 'os=' + os

    router params, (body) ->
      console.log body
      callback body

  getDeviceByQ = (query, callback) ->
    params = 'q=' + query

    router.getdevices params, (body) ->
      callback body

  createDevice = (device, callback) ->
    request = require('request')
    request.post 'https://dandpb.fwd.wf/devices', {form:device}, (error, response, body) ->
      console.log 'cheguei aqui' + response.statusCode
      if (!error && response.statusCode == 201)
        console.log 'Looog ' + body
        callback null, body

  parseRequest = (args, callback) ->
    request = require('request')
    action = args[0]
    console.log 'Action: ' + action

    if action == 'want' && args[1]?
      console.log 'Action want'
      code = args[1]
      #post device code
#      response = httpGet(serverURL + args[1])
    else if action == 'get'
      console.log 'Action get'
      platform = args[1]
      if args[1] != null
        console.log 'aqui3'
        # request 'https://dandpb.fwd.wf/devices', (error, response, body) ->
        #   if (!error && response.statusCode == 200)
        #     console.log body, args, callback
        #     callback getAllDevices(callback)
#          return JSON.stringify(devices)

      else if platform == 'iphone'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
      else if platform == 'android'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
      else if platform  == 'wp'
        return args.slice(2).join(" ")
        # query parameters (args.slice(2).join(" "))
    else if action == 'create' || action == 'update'
      console.log 'Action create'

      params = {}
      params['model'] = args[1]
      params['os'] = args[2]
      params['version'] = args[3]
      params['notes'] = args[4]
      params['owner'] = args[5]
      params['status'] = 'available'
      params['date'] = ' '
      params['user'] = ' '
      if action == 'update'
        params['status'] = args[6]
        return params
      #Put updated device
      else
        callback null, params
        # return params
  #Post created device

  # post create/update device with params

  validate = (text, callback) ->
    args = text.split()
    return callback()


  executeCommand = (text, callback) ->
    async.waterfall [
      async.apply validate, text
      (cb) ->
        cb null, text.split(' ')
      (args, cb) ->
        console.log 'aqui'
        parseRequest args, cb
      (device, cb) ->
        createDevice device, cb
      (response, cb) ->
        return cb null, response
    ], callback

  execute: executeCommand,