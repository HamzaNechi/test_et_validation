import mongoose from 'mongoose';
const { Schema, model } = mongoose;
const ReportSchema = new Schema({
    
    date:{
        type: String
    },
    mood:{
        type: String
    },
    depressedMood:{
        type: Number
    },
   
    elevatedMood:{
        type: Number
    },
    irritabilityMood:{
        type: Number
    },
    user: {
         type: Schema.Types.ObjectId, 
         ref: 'user' 
    },
},
{
    timestamp:true
}
);

export default mongoose.model('report',ReportSchema);