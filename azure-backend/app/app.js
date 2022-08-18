const express = require('express');
const bodyParser = require('body-parser');
const axios = require('axios').default;
const { v4: uuidv4 } = require('uuid');
const app = express();

app.use(bodyParser.urlencoded({ extended: false }));
app.use(bodyParser.json());

let key = "API_KEY";
let endpoint = "https://api.cognitive.microsofttranslator.com";

let location = "AZURE_RESOURCE_LOCATION";

async function translate(text, languageFrom, languageTo, transliterate) {
  try {
    let parameters = {
      'api-version': '3.0',
      'from': languageFrom,
      'to': [languageTo],
    }

    if (transliterate) {
      parameters = {
        'api-version': '3.0',
        'from': languageFrom,
        'to': [languageTo],
        'toScript': 'latn'
      }
    }

    let response = await axios({
      baseURL: endpoint,
      url: '/translate',
      method: 'post',
      headers: {
        'Ocp-Apim-Subscription-Key': key,
        'Ocp-Apim-Subscription-Region': location,
        'Content-type': 'application/json',
        'X-ClientTraceId': uuidv4().toString()
      },
      params: parameters,
      data: [{
        'text': text
      }],
    });

    if (response.status == 200) {
      console.log(response.status);
    }

    return response.data;
  } catch (error) {
    console.error(error);
  }
}


app.get('/', (req, res) => {
  res.send("Hello World!").end;
});

app.post('/translate', (req, res) => {
  let requestJSON = req.body;
  translate(requestJSON['text'], requestJSON['languageFrom'], requestJSON['languageTo'], requestJSON['transliterate']).then(response => res.json(response).status(200).end());
});

module.exports = app;