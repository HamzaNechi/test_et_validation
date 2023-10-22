import mongoose from 'mongoose'
const { Schema, model } = mongoose

export default model('reclamation',new Schema(
        {
            email: { 
                type: String ,
                required:true
            },
            message: {
                type: String,
                required:true
            },
            date: {
                type: Date,
                default: Date.now(),
            },
        },
        {
            timestamp: true,
        }
    )
)
