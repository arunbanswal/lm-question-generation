# --compute-ppl
##############################################################
# Generate Pseudo QA Dataset on SQuADShifts (Gold reference) #
##############################################################
[DONE]
qa_generation_squadshifts_ref () {
  ANCHOR_MODEL=${1}
  BATCH=16
  for NAME in 'amazon' 'new_wiki' 'nyt' 'reddit'
  do
    lmqg-generate-qa --use-reference-answer -m "lmqg/${ANCHOR_MODEL}-qg" -l "en" -d "lmqg/qa_squadshifts" -n "${NAME}" -b "${BATCH}" -e "qa_squadshifts_pseudo/${ANCHOR_MODEL}.qg_reference.${NAME}"
  done
}

qa_generation_squadshifts_ref "t5-small-squad"
qa_generation_squadshifts_ref "t5-base-squad"
qa_generation_squadshifts_ref "t5-large-squad"
qa_generation_squadshifts_ref "bart-base-squad"
qa_generation_squadshifts_ref "bart-large-squad"

########################################################
# Generate Pseudo QA Dataset on SQuADShifts (Pipeline) #
########################################################
[STONE]
qa_generation_squadshifts_pipeline () {
  ANCHOR_MODEL=${1}
  BATCH=16
  for NAME in 'amazon' 'new_wiki' 'nyt' 'reddit'
  do
    lmqg-generate-qa -m "lmqg/${ANCHOR_MODEL}-qg" --model-ae "lmqg/${ANCHOR_MODEL}-ae" -l "en" -d "lmqg/qa_squadshifts" -n "${NAME}" -b "${BATCH}" -e "qa_squadshifts_pseudo/${ANCHOR_MODEL}.pipeline.${NAME}"
  done
}

qa_generation_squadshifts_pipeline "t5-small-squad"
qa_generation_squadshifts_pipeline "t5-base-squad"
qa_generation_squadshifts_pipeline "t5-large-squad"
qa_generation_squadshifts_pipeline "bart-base-squad"
qa_generation_squadshifts_pipeline "bart-large-squad"

###################################################
# Generate Pseudo QA Dataset on SQuADShifts (E2E) #
###################################################
[UKRI]
qa_generation_squadshifts_end2end () {
  ANCHOR_MODEL=${1}
  BATCH=16
  for NAME in 'amazon' 'new_wiki' 'nyt' 'reddit'
  do
    lmqg-generate-qa -m "lmqg/${ANCHOR_MODEL}-qag" -l "en" -d "lmqg/qa_squadshifts" -n "${NAME}" -b "${BATCH}" -e "qa_squadshifts_pseudo/${ANCHOR_MODEL}.end2end.${NAME}"
  done
}

qa_generation_squadshifts_end2end "t5-small-squad"
qa_generation_squadshifts_end2end "t5-base-squad"
qa_generation_squadshifts_end2end "t5-large-squad"
qa_generation_squadshifts_end2end "bart-base-squad"
qa_generation_squadshifts_end2end "bart-large-squad"


#########################################################
# Generate Pseudo QA Dataset on SQuADShifts (Multitask) #
#########################################################
[UKRI]
qa_generation_squadshifts_multitask () {
  ANCHOR_MODEL=${1}
  BATCH=16
  for NAME in 'amazon' 'new_wiki' 'nyt' 'reddit'
  do
    lmqg-generate-qa -m "lmqg/${ANCHOR_MODEL}-qg-ae" -l "en" -d "lmqg/qa_squadshifts" -n "${NAME}" -b "${BATCH}" -e "qa_squadshifts_pseudo/${ANCHOR_MODEL}.multitask.${NAME}"
  done
}

qa_generation_squadshifts_multitask "t5-small-squad"
qa_generation_squadshifts_multitask "t5-base-squad"
qa_generation_squadshifts_multitask "t5-large-squad"
