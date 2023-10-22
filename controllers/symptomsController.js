import { validationResult } from 'express-validator';
import isEmail from 'validator/lib/isEmail.js';
import therapy from '../models/therapy.js';
import symptoms from '../models/symptoms.js';

import user from '../models/user.js';



export function getAll(req, res) {
    therapy
        .find({})
        .then(docs => {
            res.status(200).json(docs);
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });

}


export function getSymptomsByUserId(req, res) {
    const idUser = req.params.idUser;
    symptoms
        .find({ idUser: idUser })
        .then(docs => {
            if(docs != []){
                res.status(200).json(docs);
            }else{
                res.status(400).json(docs);
            }
            
        })
        .catch(err => {
            res.status(500).json({ error: err });
        });
}


export function addSymptom(req, res)  {
   // const idUser = req.params.idUser;

    console.log(req.body);
        symptoms
        .create({
            idUser : req.body.idUser,

            elevated_mood_day: req.body.elevated_mood_day,
            elevated_mood_week: req.body.elevated_mood_week,
            inflated_self_esteem: req.body.inflated_self_esteem,
            decreased_sleep: req.body.decreased_sleep,
            talkative_or_pressure_to_talk: req.body.talkative_or_pressure_to_talk,
            racing_thoughts: req.body.racing_thoughts,
            distractibility: req.body.distractibility,
            increased_activity: req.body.increased_activity,
            risky_behavior: req.body.risky_behavior,
            severe_mood_disturbance: req.body.severe_mood_disturbance,
            not_due_to_substance_or_medical_condition: req.body.not_due_to_substance_or_medical_condition,
            angrypercentage: req.body.angrypercentage,
            sadpercentage: req.body.sadpercentage,
            happypercentage: req.body.happypercentage,
            neutralpercentage: req.body.neutralpercentage,
            surprisepercentage: req.body.surprisepercentage,
            fearpercentage: req.body.fearpercentage,
            disgustpercentage: req.body.disgustpercentage,
            questions: req.body.questions,
          
            
        })
        .then(newSymptoms => {
            res.status(201).send({ symptoms: newSymptoms });
        })
        .catch(err => {
            console.error(err);
            
            res.status(500).json({ error: err });
        });
  

};