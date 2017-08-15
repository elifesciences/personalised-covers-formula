<?php

return [
	{% if pillar.elife.env in ['ci', 'dev']  %}
	'debug' => true,
	{% else %}
	'debug' => false,
	{% endif %}
	'aws_region' => "{{ pillar.personalised_covers.aws.region }}",
	'aws_bucket' => "{{pillar.personalised_covers.aws.bucket}}",
	'elife_api' => "{{ pillar.personalised_covers.api }}",
	'landing_page_url' => "{{pillar.personalised_covers.landing_page}}",
];

