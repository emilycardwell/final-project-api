

## Chord Progression Predictions API

### API running on Google Cloud Run using a Docker image.

#### Takes a series of chords and outputs a predicted next chord in the progression:

- uses NLP to predicted n next chords from a given series
- allows the user to select "randomness," or complexity of the output chords based on their decreasing probability of occurence.
