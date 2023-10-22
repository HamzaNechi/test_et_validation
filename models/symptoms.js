import mongoose from 'mongoose';

const { Schema, model } = mongoose;
const SymptomsSchema = new Schema({
    idUser: { type: Schema.Types.ObjectId, ref: 'user' },


    //symptoms
    elevated_mood_day: { type: Number 
    ,default: 0},

    elevated_mood_week: { type: Number ,default: 0},

    inflated_self_esteem: { 
        type: Number ,default: 0
    },
    decreased_sleep: { type: Number,default: 0 },

    talkative_or_pressure_to_talk: { type: Number ,default: 0},

    racing_thoughts: { type: Number ,default: 0},

    distractibility: { type: Number ,default: 0},

    increased_activity: { type: Number,default: 0 },

    risky_behavior: { type: Number ,default: 0},

    severe_mood_disturbance: { type: Number,default: 0 },

    not_due_to_substance_or_medical_condition: { type: Number ,default: 0},

    angrypercentage: {     type: [Number], 
        default: []},

    sadpercentage: {     type: [Number], 
        default: []},

    happypercentage: {     type: [Number], 
        default: []},

    neutralpercentage: {     type: [Number], 
        default: []},

    surprisepercentage: {     type: [Number], 
        default: []},

    fearpercentage: {     type: [Number], 
        default: []},

    disgustpercentage: {     type: [Number], 
        default: []},
    questions:{     type: [Number], 
        default: []},

    
    
  
},
    {
        timestamp: true
    }
);

export default mongoose.model('symptoms', SymptomsSchema);