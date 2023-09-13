
data {
  int<lower=1> N; // number of observations
  int<lower=1> J; // number of groups
  array[J] int s; // number of time periods for each group; trick for ragged arrays
  array[N] int<lower=0> n_dissent_events; // number of dissent events
  array[N] int<lower=0> n_events; // total number of events
}

parameters {
  real Mu;
  real<lower=0> sigma_mu;
  real<lower=0> sigma_alpha;
  real<lower=1> nu_mu;
  real<lower=1> nu_alpha;
  array[N] real alpha; // innovations on logit scale
  array[J] real mu;    // group-level mean intensity on logit scale
}

transformed parameters {
  array[N] real eta;
  {  // bracket is a trick to "hide" this unallowed integer from the block
  // below, I use a trick for ragged arrays
  int pos;
  pos = 1;
  for (j in 1:J) {
    for (t in 1:s[j]) {
      eta[(pos - 1) + t] = mu[j] + alpha[(pos - 1) + t]; 
    }
    pos = pos + s[j];
  }
  }
}

model {
  sigma_mu ~ cauchy(0, 3);
  sigma_alpha ~ cauchy(0, 3);
  nu_mu ~ gamma(2, 0.1);
  nu_alpha ~ gamma(2, 0.1);
  mu ~ student_t(nu_mu, Mu, sigma_mu);
  alpha ~ student_t(nu_alpha, 0, sigma_alpha);
  n_dissent_events ~ binomial_logit(n_events, eta);
}

generated quantities {
  vector[N] log_lik;
  for (i in 1:N) {
    log_lik[i] = binomial_logit_lpmf(n_dissent_events[i] | n_events[i], eta[i]);
  }
}
