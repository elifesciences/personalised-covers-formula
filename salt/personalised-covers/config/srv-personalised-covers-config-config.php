<?php

return [
	{% if pillar.elife.env not in ['prod', 'end2end', 'continuumtest']  %}
	'debug' => true,
	{% else %}
	'debug' => false,
	{% endif %}
	'aws_region' => "{{ pillar.personalised_covers.aws.region }}",
	'aws_bucket' => "{{pillar.personalised_covers.aws.bucket}}",
	'elife_api' => "{{ pillar.personalised_covers.api }}",
	'landing_page_url' => "{{pillar.personalised_covers.landing_page}}",
	'font_path' => '/srv/personalised-covers/data/fonts/output',
	'cover_images' => [
		'load_paths' => [
			'a4' => '/srv/personalised-covers-data/formats/a4',
			'letter' => '/srv/personalised-covers-data/formats/letter'
		],
	],
	'gtm_id' => "{{ pillar.personalised_covers.gtm_id }}",
];

