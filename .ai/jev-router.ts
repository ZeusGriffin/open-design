import { experimental_evaluate as evaluate } from 'ai';

export type JevNextStep = 'continue' | 'retry' | 'ask' | 'stop';

export async function jevRoute(state: string) {
  return evaluate({
    model: 'typesafe-ai/jev',
    state,
    questions: {
      nextStep: {
        type: 'choice',
        options: ['continue', 'retry', 'ask', 'stop'],
        instructions: 'Choose the safest useful next step for the workflow.',
      },
      verified: {
        type: 'boolean',
        instructions: 'Does the current result satisfy the stated acceptance checks?',
      },
    },
  });
}
