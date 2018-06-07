const config = require('./config.json');
const service = require('./client_secret.json');
const { google } = require('googleapis');
const pubsub = google.pubsub({
    version: 'v1',
    auth: new google.auth.JWT(
      service.client_email,
      './client_secret.json',
      null,
      ['https://www.googleapis.com/auth/pubsub'])
  });

/**
 * Log event info.
 *
 * @param {object} req Cloud Function request context.
 */
function logEvent(req) {
  console.log(`HEADERS ${JSON.stringify(req.headers)}`);
  console.log(`EVENT ${JSON.stringify(req.body.event)}`);
  return req;
}

/**
 * Verify request contains proper validation token.
 *
 * @param {object} req Cloud Function request context.
 */
function verifyToken(req) {
  // Verify token
  if (!req.body || req.body.token !== config.slack.verification_token) {
    const error = new Error('Invalid Credentials');
    error.code = 401;
    throw error;
  }
  return req;
}

/**
 * Publish event to PubSub topic (if it's not a retry).
 *
 * @param {object} req Cloud Function request context.
 */
function publishEvent(req) {
  // Skip if this is a Slack retry event (there must be a better way to handle this...)
  if (req.headers['x-slack-retry-num'] !== undefined) return Promise.resolve(req);

  // Publish event to PubSub if it is an `event_callback`
  if (req.body.type === 'event_callback') {
    return pubsub.projects.topics.publish({
        topic: `projects/${config.google.project}/topics/${req.body.event.type}`,
        resource: {
          messages: [
            {
              data: Buffer.from(JSON.stringify(req.body)).toString('base64')
            }
          ]
        }
      })
      .then((pub) => {
        console.log(`PUB/SUB ${JSON.stringify(pub.data)}`);
        return req;
      });
  }

  // Resolve request without publishing
  return Promise.resolve(req);
}

/**
 * Send OK HTTP response back to requester.
 *
 * @param {object} req Cloud Function request context.
 * @param {object} res Cloud Function response context.
 */
function sendResponse(req, res) {
  if (req.body.type === 'url_verification') {
    console.log('CHALLENGE');
    res.json({challenge: req.body.challenge});
  } else {
    console.log('OK');
    res.send('OK');
  }
  return req;
}

/**
 * Send Error HTTP response back to requester.
 *
 * @param {object} err The error object.
 * @param {object} req Cloud Function request context.
 */
function sendError(err, res) {
  console.error(err);
  res.status(err.code || 500).send(err);
  return Promise.reject(err);
}

/**
 * Responds to any HTTP request that can provide a "message" field in the body.
 *
 * @param {object} req Cloud Function request context.
 * @param {object} res Cloud Function response context.
 */
exports.publishEvent = (req, res) => {
  // Respond to Slack
  Promise.resolve(req)
    .then(logEvent)
    .then(verifyToken)
    .then(publishEvent)
    .then((req) => sendResponse(req, res))
    .catch((err) => sendError(err, res));
}
