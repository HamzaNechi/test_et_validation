import express from 'express';
import mongoose from 'mongoose';
import { notFoundError, errorHandler } from './middelwares/error-handler.js';
import morgan from 'morgan';
import cors from 'cors';

import userRoute from './routes/userRoute.js';
import therapy_p from './routes/therapy-route.js';
import reservation from './routes/reservation-route.js';


import Bree from 'bree';
import reclamationRoute from './routes/reclamation.js';


import scheduleRoute from './routes/scheduleRoute.js';
import appointementRoute from './routes/appointementRoute.js';
import symptoms from './routes/symptomsRoute.js';
import reportRoute from './routes/report-route.js';



const app = express();
app.use(express.json());

app.use(express.urlencoded({ extended: true }));
app.use(cors());
app.use(morgan("dev"));
const port = process.env.PORT || 9090;
const databaseName = 'dearSelf';
const hostname = '192.168.100.132';


mongoose.set('debug', true);
mongoose.set('strictQuery',false);
mongoose.Promise = global.Promise;



//DATABASE
mongoose
  .connect(`mongodb://localhost:27017/${databaseName}`)
  .then(() => { // then ; une fois connecté afficher un msg de réussite sur la console
    console.log(`Connected to ${databaseName}`);
  })
  .catch(err => { // si erreur , affiche erreur sur console
    console.log(err);
  });



  
const bree= new Bree({
  jobs : [{
    name:'mailer',
    interval: '20s', // chaque 20 secondes
    //interval: '0 0 * * *', // exécute la tâche à minuit tous les jours
    //cron : "* * 12 * * *" //chaque 12 heures
  }]
});

bree.start()
 


app.use((req, res, next) => {
  console.log("middleware just run !");
  next();
});
app.use("/gse", (req, res, next) => {
  console.log("Middleware just ran on a gse route !");
  next();
});


app.use('/user', userRoute);
app.use('/therapy', therapy_p);
app.use('/reservation', reservation);
app.use('/reclamation',reclamationRoute);
app.use('/schedule', scheduleRoute);
app.use('/appointement', appointementRoute);
app.use('/image', express.static('public/images'));
app.use('/symptoms', symptoms);
app.use('/report', reportRoute);
app.use(notFoundError);
app.use(errorHandler);

app._router.stack.forEach(function(middleware){
  if(middleware.route){
    console.log(middleware.route);
  } else if(middleware.name === 'router'){
    middleware.handle.stack.forEach(function(handler){
      console.log(handler.route);
    });
    } } )

    app.listen(port, hostname,() => {
      console.log(`Server running at http://${hostname}:${port}/`);
    });