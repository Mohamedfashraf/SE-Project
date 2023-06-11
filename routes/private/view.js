const db = require('../../connectors/db');
const roles = require('../../constants/roles');
const { getSessionToken } = require('../../utils/session');

const getUser = async function (req) {
  const sessionToken = getSessionToken(req);
  if (!sessionToken) {
    return res.status(301).redirect('/');
  }

  const user = await db.select('*')
    .from('se_project.sessions')
    .where('token', sessionToken)
    .innerJoin('se_project.users', 'se_project.sessions.userid', 'se_project.users.id')
    .innerJoin('se_project.roles', 'se_project.users.roleid', 'se_project.roles.id')
    .first();

  console.log('user =>', user)
  user.isStudent = user.roleid === roles.student;
  user.isAdmin = user.roleid === roles.admin;
  user.isSenior = user.roleid === roles.senior;

  return user;
}

module.exports = function (app) {
  // Register HTTP endpoint to render /users page
  app.get('/dashboard', async function (req, res) {
    const user = await getUser(req);
    return res.render('dashboard', user);
  });

  // Register HTTP endpoint to render /users page
  app.get('/users', async function (req, res) {
    const users = await db.select('*').from('se_project.users');
    return res.render('users', { users });
  });

  // Register HTTP endpoint to render /courses page
  app.get('/stations', async function (req, res) {
    const user = await getUser(req);
    const stations = await db.select('*').from('se_project.stations');
    return res.render('stations', { ...user, stations });
  });

  app.get('/resetPassword', async function (req, res) {
    const users = await db.select('*').from('se_project.users');
    return res.render('reset-password');
  });

  app.get('/tickets', async function (req, res) {
    const users = await db.select('*').from('se_project.tickets');
    return res.render('buyTickets');
  });

  app.get('/requests/refund', async function (req, res) {
    try {
      const user = await getUser(req);
      const userId = user.userid;
      const tickets = await db.select('id').from('se_project.refund_requests').where('userid', userId);

      return res.render('requestRefund', { tickets });
    } catch (error) {
      console.error(error);
      res.status(500).send('Internal Server Error');
    }
  });

  app.get('/requests/senior', async function (req, res) {
    const users = await db.select('*').from('se_project.senior_requests');
    return res.render('requestSenior');
  });

  app.get('/manage/requests/seniors', async function (req, res) {
    const users = await db.select('*').from('se_project.senior_requests');
    return res.render('manageSenior');
  });

  app.get('/manage/requests/refund', async function (req, res) {
    const users = await db.select('*').from('se_project.refund_requests');
    return res.render('manageRefund');
  });

  app.get('/rides', async function (req, res) {
    const ride = await db.select('*').from('se_project.rides');
    return res.render('rides', { ride });
  });

  app.get('/subscriptions', async function (req, res) {
    const subscriptions = await db.select('*').from('se_project.subscription');
    return res.render('subscriptions', { subscriptions });
  });

  app.get('/routes', async function (req, res) {
    const routes = await db.select('*').from('se_project.routes');
    return res.render('routes', { routes });
  });

  app.get('/status', async function (req, res) {
    const senior_requests = await db.select('*').from('se_project.senior_requests');
    const refund_requests = await db.select('*').from('se_project.refund_requests');
    return res.render('status', { senior_requests, refund_requests });
  });

  app.get('/buyTicketsBySubscription', async function (req, res) {
    const subscription = await db.select('*').from('se_project.subscription');
    const ticket = await db.select('*').from('se_project.tickets');
    return res.render('ticketSub', { subscription, ticket });
  });

  app.get('/checkPrice', async function (req, res) {
    const pStations = await db.select('*').from('se_project.stations');
    const proutes = await db.select('*').from('se_project.routes');
    return res.render('checkPrice', { pStations, proutes });
  });

  app.get('/admin/stations', async function (req, res) {
    const users = await db.select('*').from('se_project.stations');
    return res.render('manageStations');
  });
  app.get('/addStation', async function (req, res) {
    const users = await db.select('*').from('se_project.stations');
    return res.render('addStation');
  });
  app.get('/updateStations', async function (req, res) {
    const users = await db.select('*').from('se_project.stations');
    return res.render('updateStation');
  });
  app.get('/admin/routes', async function (req, res) {
    const users = await db.select('*').from('se_project.routes');
    return res.render('manageRoutes');
  });
  app.get('/addRoute', async function (req, res) {
    const users = await db.select('*').from('se_project.routes');
    return res.render('addRoute.hjs');
  });
  app.get('/updateRoutes', async function (req, res) {
    const users = await db.select('*').from('se_project.routes');
    return res.render('updateRoute');
  });
  app.get('/deleteRoutes', async function (req, res) {
    const users = await db.select('*').from('se_project.routes');
    return res.render('deleteRoute');
  });
  app.get('/admin/zones', async function (req, res) {
    const users = await db.select('*').from('se_project.zones');
    return res.render('updateZonePrice');
  });
  app.get('/deleteStations', async function (req, res) {
    const users = await db.select('*').from('se_project.stations');
    return res.render('deleteStation');
  });

};